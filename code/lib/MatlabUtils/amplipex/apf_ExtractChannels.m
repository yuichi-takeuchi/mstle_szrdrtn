function apf_ExtractChannels(srcName, destName, Channels, nChannels)
%
% USAGE:
%    apf_ExtractChannels(inputName,outputName, Channels, nChannels)
%    This function extracts specified channels from a dat file
%    and creates a new dat file
% INPUTS:
%    srcName: Name string of source dat file (eg. 'source.dat')
%    destName: Name string of destination dat file (eg. 'destination.dat')
%    Channels: Channel vector to be extracted and reordered.
%    nChannels: Total number of channels in the source dat file
% 
% Copyright (C) 2016, 2020 Yuichi Takeuchi

if nargin ~= 4
  error('Incorrect number of parameters (type ''help <a href="matlab:help apf_ExtractChannels">apf_ExtractChannels</a>'' for details).');
end

fprintf('Extracting %s ch from %s ...\n', num2str(Channels), srcName)
infoFile = dir(srcName);

chunk = 1e6;
nChunks = floor(infoFile.bytes/(nChannels*chunk*2));
% warning off
if nChunks == 0
    chunk = infoFile.bytes/(nChannels*2);
end

% Starting information
disp('Extracting channels...');

% Open input file and output file
inputFile = fopen(srcName,'r');
outputFile = fopen(destName,'w');

% Read first chunk
[d,~] = fread(inputFile,[nChannels,chunk],'int16');
% extract channels
d = d(Channels, :);
fwrite(outputFile,d,'int16');

% Read subsequent chunks
for k = 1:nChunks-1
    fprintf('%d of %d chunks\n', k, (nChunks-1))
    [d,~] = fread(inputFile,[nChannels,chunk],'int16');
    d = d(Channels, :); % extract channels
    fwrite(outputFile,d,'int16');
end

if nChunks
    newchunk = infoFile.bytes/(2*nChannels)-nChunks*chunk;
    if newchunk
        [d,~] = fread(inputFile, [nChannels, newchunk], 'int16');
        d = d(Channels, :);
        fwrite(outputFile,d,'int16');
    end
end
% Warning on

fclose(inputFile);
fclose(outputFile);

% Finishing info
disp('Extraction done.');
