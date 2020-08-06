function [Timestamp, Cluster] = ssf_ReadKwik(Filebase, ChannelGroup)
%
%   [Timestamp, Cluster] = ssf_ReadKwik(Filebase, ChannelGroup)
%
% INPUTS:
%   Filebase: base name of the .kwik file to be read
%   ChannelGroup: number of a target shank
%
% Copyright (C) Yuichi Takeuchi 2017
%

% Starting...
disp('Extracting Timestamp and Cluster...')

% Reading Time Stamps...
Timestamp = h5read([Filebase '.kwik'], ['/channel_groups/' num2str(ChannelGroup) '/spikes/time_samples']);

% Reading and Renaming Clusters...
Clu = h5read([Filebase '.kwik'],['/channel_groups/' num2str(ChannelGroup) '/spikes/clusters/main']);
Cluster_names = unique(Clu);

% setting noise as 0 and MUA as 1
% if more groups: 3,4,5... and so on

for ind = 1:length(Cluster_names)
    cluster_group = h5readatt([Filebase '.kwik'],['/channel_groups/' num2str(ChannelGroup) '/clusters/main/' num2str(Cluster_names(ind))],'cluster_group');
    if cluster_group == 0  % NOISE
        Clu(Clu == Cluster_names(ind)) = -2;
    elseif cluster_group == 1  % MUA
        Clu(Clu == Cluster_names(ind)) = -1;
    end
end

% Rename and order name of clusters from 1 to n
all_names = unique(Clu);
Clu2 = Clu;
counter = 2;
for ii = 1:length(all_names)
    switch all_names(ii)
        case -2
            Clu2(Clu == all_names(ii),1) = 0;
        case -1
            Clu2(Clu == all_names(ii),1) = 1;
        otherwise
            Clu2(Clu == all_names(ii),1) = counter;
       counter = counter + 1;
    end
end
Cluster = Clu2;

disp('done.');


