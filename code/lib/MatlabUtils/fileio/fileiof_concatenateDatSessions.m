function [ flag ] = fileiof_concatenateDatSessions( filenamelist, destName )
%
% [ flag ] = fileiof_concatenateDatSessions( filenamelist, destName )
% INPUTS:
%    filenamelist: string vector of srcfiles (eg. 'source.dat')
%    destName: Name string of destination dat file (eg. 'destination.dat')
%
% Copyright (c) 2017, 2020 Yuichi Takeuchi

flag = 0;

% Open input file and output file
fid = fopen(destName,'w');

% Starting information
tic
disp('starting merging...');
for k = 1:length(filenamelist)
    fprintf('%d of %d', k, length(filenamelist))
    disp(['Adding ' filenamelist{k}])
    m = memmapfile(filenamelist{k},'Format','int16','writable',true);
    fwrite(fid,m.Data,'int16');
end
fclose(fid);

% Finishing info
disp('concatenation done.');
toc
flag = 1;

end

