function [ flag ] = fileiof_getMutipleTimeWinsTogetherIntoBinary1( srcName, segments, channels, nChannels, destName )
%
% [ flag ] = fileiof_concatenateDatSessions( filenamelist, destName )
% INPUTS:
%   srcName: Name string of source dat file (e.g 'source.dat')
%   segments: matrix of onset and offset index pairs (n * 2) e.g. [1001 2000] 
%   channels: channels to get (vector)
%   nChannels: total number of channels in the source dat file
%   destName: Name string of destination dat file (e.g. 'destination.dat')
%
% Copyright (c) 2020 Yuichi Takeuchi

flag = 0;
infoFile = dir(srcName);
nSamples = floor(infoFile.bytes/(nChannels*2));
m = memmapfile(srcName,'Format', {'int16', [nChannels nSamples], 'x'});
fid = fopen(destName,'w');
for k = 1:size(segments,1)
    fprintf('%d of %d\n', k, size(segments,1))
    period = segments(k,1):segments(k,2);
    fwrite(fid,m.Data.x(channels,period),'int16');
end
fclose(fid);

% Finishing info
disp('concatenation done.');
flag = 1;

end

