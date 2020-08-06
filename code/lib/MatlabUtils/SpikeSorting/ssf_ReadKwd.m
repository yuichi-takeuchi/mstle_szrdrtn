function [Feature] = ssf_ReadKwd(Filebase, ChannelGroup)
%
%   [Feature] = ssf_ReadKwd(Filebase, ChannelGroup)
%
% USAGE:
%   [Feature] = ssf_ReadKwd(Filebase, ChannelGroup)
% INPUTS:
%   Filebase: base name of the .kwik file to be read
%   ChannelGroup: number of a target shank
%
% Copyright (C) Yuichi Takeuchi 2017
%

% Reading features...
Feature = h5read([Filebase '.kwx'],['/channel_groups/' num2str(ChannelGroup) '/features_masks']);



