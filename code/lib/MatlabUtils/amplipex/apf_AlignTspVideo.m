function apf_AlignTspVideo(fbasename)
%
% USAGE:
%    apf_AlignTspVideo(filebase)
%    This function provides dat file alingned timestamps for 
%    video recording
% INPUTS:
%    fbasename: Namebase string of source tsp .file
%
% OUTPUTS:
%    .atsp: dat file aligned timestamp (in ms)
%    
% (C) 2016 Yuichi Takeuchi

% get timestamps and positions from tsp file
tspdata=load([fbasename '.tsp']);

%get start and end timestamp of dat file
fid=fopen([fbasename '.meta']);
tline= fgetl(fid);
while ischar(tline)
    try
       if strcmp(tline(1:20),'TimeStamp of the end')
       tline=tline(59:end);
        EndTimestamp=sscanf(tline,'%d',1);
       end
    catch
    end
    try
        if strcmp(tline(1:22),'TimeStamp of the start')
            tline=tline(61:end);
            StartTimestamp=sscanf(tline,'%d',1);
        end
    catch
    end
    try
        if strcmp(tline(1:9),'Number of')
            tline=tline(31:end);
            ChanNum=sscanf(tline,'%d',1);
        end
    catch
    end
    try
        if strcmp(tline(1:9),'File size')
            tline=tline(21:end);
            DatSize=sscanf(tline,'%lu',1);
        end
    catch
    end
    
    tline= fgetl(fid);
end
fclose(fid);

% Caluculate
relativetsp = tspdata - StartTimestamp;

%Calculate file length from dat file
DatLength=double(DatSize/(ChanNum*2*20)); %Dat file size in ms
TspLength=EndTimestamp-StartTimestamp;

%remove lines from tspdata which has the same timestamp as the previous
%does
repeatingts=find(tspdata(1:end-1,1)==tspdata(2:end,1))+1;
for r=size(repeatingts):-1:1
    tspdata(repeatingts(r),:)=[];
end

%interpolate to 1 kHz - computer clock
t=tspdata(1,1):tspdata(end,1);
interpTsp1kHz = zeros(length(t),1);
interpTsp1kHz(:,1)=t;

%align the beginning
if (StartTimestamp<tspdata(1,1)) 
    i=1:tspdata(1,1)-StartTimestamp;
    tspnew(i,1)=StartTimestamp+i-1;
    tspnew=[tspnew; interpTsp1kHz];
else
    tspnew=interpTsp1kHz(StartTimestamp-tspdata(1,1)+1:end,1);
end
clear i

%adjust the end
if (EndTimestamp<tspnew(end,1)) 
    tspnew=tspnew(1:find(tspnew(:,1)==EndTimestamp),1);
else
    t = tspnew(end,1)+1:EndTimestamp;
    tspnew=[tspnew; t'];
end
clear t interpTsp1kHz

vsrms = length(tspdata)/(tspdata(end,1) - tspdata(1,1));
flamelag = fix((tspdata(1,1) - StartTimestamp)*vsrms);
tspnewsub = tspnew - tspnew(1,1) + flamelag;
tspout = fix(linspace(tspnewsub(1,1), tspnewsub(end,1), length(tspnewsub)*vsrms))';

dlmwrite([fbasename '.atsp'],tspout,'delimiter','\t', 'precision', 10);


