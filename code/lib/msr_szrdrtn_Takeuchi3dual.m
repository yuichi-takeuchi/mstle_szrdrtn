function [DataStruct] = getDataStruct(datString,srLFP)
% datstring: e.g. 'AP_190812_exp1_1'
% Copyright (C) 2018–2020 Yuichi Takeuchi

%% Get timestamps from a digital channel and build a data structure
% Get timestamp cell vector from each digital channel .dat file
[ TSCellVector ] = digchf_dig2TimestampCellVector1( datString, 0.1, srLFP);

% Build a data structure (DatFile x RatNo x Trial timwstamps)
i = 1:numel(RecInfo.datString);
DataStruct(i).datafilenamebase = RecInfo.datString{i}; 
FldrInfoLFP = dir([RecInfo.datString{i} '*_LFP_reorg.dat']);
DataStruct(i).datfilename = string({FldrInfoLFP.name});
DataStruct(i).Timestamp = TSCellVector{i};
DataStruct(i).TimestampMin = double(TSCellVector{i}{1,1})/(RecInfo.srLFP*60);

% Save the DataStruct variable
save([RecInfo.datfilenamebase '_DataStruct.mat'], 'DataStruct')

clear i TSCellVector FldrInfoLFP

%% Manual curation of timestamp
% i = 1;
% index = [3 6 7 8];
% DataStruct(i).Timestamp{1, 2}(index,:) = [];
% DataStruct(i).TimestampMin(index,:) = [];
% save([RecInfo.datfilenamebase '_DataStruct.mat'], 'DataStruct')
% clear i index

%% Set params for main processes
cParams.sr = RecInfo.srLFP;
cParams.TSbit = 1; % bit of digital channel for timestamp stimulus onset detection
cParams.nChannel = 30; % total number of channel of each rat
cParams.ChLabel = ["MEC" "rHPC" "lHPC" "Ctx"];
cParams.ChOrder = {1:6 7:15 16:24 25:30}; % {1:6 7:15 16:24 25:30}
cParams.BaselineDrtn = uint64(floor(30*cParams.sr)); % 30 s baseline before stimulation
cParams.TestDrtn = uint64(floor(180*cParams.sr)); % 180 s test period after stimulation

%% Seizure detection: Band-pass filt-Rectification-movmean filtfilt signal pre-processing, RMS thresholding
[ flag ] = eplpsyf_detectEvokedSeizureBPFltMvmnRMSThrshld1( RecInfo, DataStruct, cParams, true, true);

%% Regional plot: Actual traces
[ flag ] = figsf_checkTimedTracesOfGroups1( RecInfo, DataStruct, cParams);
 
%% Multi-tspectgramc (chronux Toolbox)
% Set parameters
params.tapers = [3,5]; % TW 2TW-1
params.pad = 0;
params.Fs = RecInfo.srLFP; %sample frequency
params.fpass = [0.3 100];
params.err = [1,0.05];
params.trialave = 0;
movingwin = [3,1.5]; %length = 3s,overlapping 50%

[ flag ] = figsf_evokedTFSpctrgrmChrouxSurf1( RecInfo, DataStruct, cParams, params, movingwin );
clear flag params movingwin

%% Wavelet time-frequencty plot for each graph
DataNo = 1;
RatNo = 1;
TrialNo = 1;
ChNo = 8;
[ flag ] = figsf_evokedScalogramSurf1( RecInfo, DataStruct, DataNo, RatNo, TrialNo, ChNo, cParams );
clear DataNo RatNo TrialNo ChNo

%% Wavelet Scalogram of brain regions (subplots)
DataNo = 1;
RatNo = 1;
TrialNo = 6;
Chs = [1 7 16 25]; % {1:6 7:15 16:24 25:30}
[ flag ] = figsf_evokedScalogramSubSurf1( RecInfo, DataStruct, DataNo, RatNo, TrialNo, Chs, cParams );
clear DataNo RatNo TrialNo Chs

end
