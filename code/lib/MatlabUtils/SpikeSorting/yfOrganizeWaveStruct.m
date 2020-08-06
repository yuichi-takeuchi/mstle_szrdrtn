function yfOrganizeWaveStruct()
%
% 
% Copyright (C) 2016 by Yuichi Takeuchi

cd('C:\Users\Lenovo\Documents\MATLAB')
[filename, pathname] = uigetfile({'*.dat'},'Select dat file');
if ~ischar(filename)
    error('cancelled')
else
    filename_dat = filename;
end

[filename, pathname] = uigetfile({'*.kwik'},'Select kwik file');
if ~ischar(filename)
    error('cancelled')
else
    filename_kwik = filename;
end

Filebase = filename_dat(1:length(filename_dat)-4);

Data_Raw = LoadBinaryZ(Filebase, 'nChannels', 32);
Data_Lowpass = yfLowPassButter2(Data_Raw);
Data_Highpass = yfHighPassButter2(Data_Raw);
StructOut = yfReadKwikStructOut(Filebase, [0], Data_Highpass);

save([pathname Filebase '.mat'],'Data_Raw', 'Data_Lowpass', 'Data_Highpass', 'StructOut');

