function fileiof_MultiPPTSlideSave( StrFileNameFormat, pptfilename )
%FILEIOF_SINGLEPPTSLIDESAVE Summary of this function goes here
%   StrWmfFileNameFormat: as 'tempfigure*.wmf'
%   pptfilename: as 'temp.ppt'
%
% Copyright (C) Yuichi Takeuchi 2017

s = dir(StrFileNameFormat);
SrcFileNameList = {s.name};
fullpath = pwd;
[ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, pptfilename );
delete(StrFileNameFormat)

end

