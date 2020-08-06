function [flag] = yfWriteDatFile(srcVar,destName)
%
% USAGE:
%    yfWriteDatFile(srcVar,destName)
%    This makes a new dat file from a specified variable
%
% INPUTS:
%    srcVar: Name of input variable
%    destName: Name string of destination dat file (eg. 'destination.dat')
% 
% Copyright (C) 2016, 2020 Yuichi Takeuchi
%

flag = 0;

if nargin ~= 2
  error('Incorrect number of parameters (type ''help <a href="matlab:help yfWriteDatFile">yfWriteDataFile</a>'' for details).');
end

% fprintf('Writing %s ...\n', destName)
fid = fopen(destName,'w');
fwrite(fid,srcVar,'int16');
fclose(fid);
% disp('Done.');
flag = 1;



