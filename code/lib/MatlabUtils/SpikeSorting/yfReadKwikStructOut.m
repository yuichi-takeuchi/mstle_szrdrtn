function [StructOut] = yfReadKwikStructOut(Filebase, SpikeFilebase, ChannelGroup, nChannels)
%
% USAGE:
%   [StructOut] = function yfReadKwikandStructOut(Filebase, ChannelGroup, nChannels)
%
% INPUTS:
%   Filebase: base name of the .kwik file to be read
%   SpikeFilebase: base name of the .dat file to be read
%   ChannelGroup: shanks
%   nChannels: total number of recording channels
%
% (C) Yuichi Takeuchi 2015, 2017

% Starting...
tic % -> aprox 5-10min per shank but depending on recording time...
disp('Organizing structure...')
h = waitbar(0,'Organizing structure...');

StructOut = struct('ChannelGroup', {}, 'Timestamp', {}, 'Cluster', {}, 'Feature', {}, 'Waveforms', {}, 'AvgWaveforms', {}, 'StdWaveforms', {});

for k = ChannelGroup(1):ChannelGroup(end) % number of shank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    waitbar(k/length(ChannelGroup))
    
    % Reading Time Stamps...
    Spkts = h5read([Filebase '.kwik'], ['/channel_groups/' num2str(k) '/spikes/time_samples']);
       
    % Reading and Renaming Clusters...
    Clu = h5read([Filebase '.kwik'],['/channel_groups/' num2str(k) '/spikes/clusters/main']);
    Cluster_names = unique(Clu);

    % setting noise as 0 and MUA as 1
    % if more groups: 3,4,5... and so on

    for ind = 1:length(Cluster_names)
        cluster_group = h5readatt([Filebase '.kwik'],['/channel_groups/' num2str(k) '/clusters/main/' num2str(Cluster_names(ind))],'cluster_group');
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

    % Reading features...
    Features = h5read([Filebase '.kwx'],['/channel_groups/' num2str(k) '/features_masks']);
    
    % Extracting spikes (The function exists below)
   [Waveforms, AvgWaveforms, StdWaveforms] = yfExtractSpikes(SpikeFilebase, nChannels, Spkts, Clu2, 32);
    
    %SAVING res and clu...
%     fid = fopen([Filebase '.clu.' num2str(k)],'w');
%     fprintf(fid,'%i\r\n',length(unique(Clu2)));
%     fprintf(fid,'%i\r\n',Clu2);
%     fclose(fid);
%     clear fid
%     
%     fid = fopen([Filebase '.res.' num2str(k)],'w'); 
%     fprintf(fid,'%i\r\n',Spkts);
%     fclose(fid);
%     clear fid
        
    % Putting vectors and matrixes into the structure
    StructOut(k+1).ChannelGroup = num2str(k);
    StructOut(k+1).Timestamp = Spkts;
    StructOut(k+1).Cluster = Clu2;
    StructOut(k+1).Feature = Features;
    StructOut(k+1).Waveforms = Waveforms;
    StructOut(k+1).AvgWaveforms = AvgWaveforms;
    StructOut(k+1).StdWaveforms = StdWaveforms;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%Finishing info
close(h)
disp('Structure organization done.');
toc
end
