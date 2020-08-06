function fileiof_SinglePPTSlideSave( pptfilename )
%FILEIOF_SINGLEPPTSLIDESAVE Summary of this function goes here
%   Detailed explanation goes here
%   pptfilename: as 'temp.ppt'
%
% Copyright (C) Yuichi Takeuchi 2017

print('-dmeta', 'tempfigure.wmf');
s = dir ('tempfigure*.wmf');
SrcFileNameList = {s.name};
fullpath = pwd;
[ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, pptfilename );
delete('tempfigure*.wmf')

end

