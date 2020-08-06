function [Waveforms, AvgWaveforms, StdWaveforms] = yfExtractSpikes(Filebase, nChannels, Timestamp, Cluster, nSamples)
%
% [Waveforms, AvgWaveforms, SdWaveforms] = yfExtractSpikesFilebase, nChannels, Timestamp, Cluster, nSamples)
%
% INPUTS:
%   Filebase: base name of the .dat file to be read
%   nChannels: total number of recording channels
%   Timestamp: Spike timestamp
%   Cluster: Cluster vectors
%   nSamples: number of samples for waveforms
% 
% Copyright (C) 2015, 2017 by Yuichi Takeuchi

DataIn = fileiof_getChannelsFromBinary1([Filebase '.dat'], 1:nChannels, nChannels);
Waveforms = zeros(size(DataIn, 1), nSamples, length(Timestamp));

for k = 1:length(Timestamp)
    width = floor(nSamples/2);
    TimeWindow = (double(Timestamp(k)) - width +1):(double(Timestamp(k)) + width);
    if(isempty(find(TimeWindow < 1, 1)) && isempty(find(TimeWindow > length(DataIn), 1))) % length(TimeWindow) == nSmaples && 
        Waveforms(:, :, k) = DataIn(:, TimeWindow);
    else
        Waveforms(:, :, k) = NaN;
    end
end

ClusterName = unique(Cluster);
AvgWaveforms = cell(1,length(ClusterName));
StdWaveforms = cell(1,length(ClusterName));

for l = 1:length(ClusterName);
    WaveformsOfACluster = Waveforms(:, :, (Cluster == ClusterName(l)));
    index = ~isnan(WaveformsOfACluster(1,1,:));
    NaNOmitted = WaveformsOfACluster(:,:,index);
    AvgWaveforms{l} = mean(NaNOmitted, 3);
    StdWaveforms{l} = std(NaNOmitted, 0, 3);
end
