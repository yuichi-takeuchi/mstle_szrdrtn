function ssf_MakeCluRes(Filebase, Clu, Spkts, ShankID)
%
% USAGE:
%   unf_MakeCluRe(Clu, Res, ShankID)
%
% INPUTS:
%   Filebase: base string for the destination files
%   Clu: cluster vector
%   Spkts: timestamp vector
%   ShankID: shank ID scalar
%   
% Copyright (C) Yuichi Takeuchi 2016

fid = fopen([Filebase '.clu.' num2str(ShankID)],'w');
fprintf(fid,'%i\r\n',length(unique(Clu)));
fprintf(fid,'%i\r\n',Clu);
fclose(fid);
clear fid

fid = fopen([Filebase '.res.' num2str(ShankID)],'w'); 
fprintf(fid,'%i\r\n',Spkts);
fclose(fid);
clear fid