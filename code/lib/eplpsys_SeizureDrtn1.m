% This routine analyses HPC and Ctx seizure durations and provides an comma
% separated value file as output
% Copyright (C) 2018-2020 Yuichi Takeuchi
clc; clear; close all
%% Organizing a recording information structure
date = 190814;
datfilenamebase = ['AP_' num2str(date) '_exp'];
expnum1 = 1;
expnum2 = 2;
% Building the RecInfo structure for meta information
RecInfo = struct(...
    'expnum1', expnum1,...
    'expnum2', expnum2,...
    'datfilenamebase', datfilenamebase,...
    'matfilenamebase', [datfilenamebase '_DatPrep_Template1'],...
    'nChannels', 63,...
    'sr', 20000,...
    'srLFP', 1250,...
    'LTR', [112 113],...
    'date', date,...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['D:\Data\LongTermRec1\LTRec1_112_113\' num2str(date)]...
    );
count = 1:numel(expnum1)*numel(expnum2); % only 
for k = expnum1
    for l = expnum2
        RecInfo.datString(count) = string([datfilenamebase num2str(k,'%02.f') '_' num2str(l,'%02.f')]);
    end
end
clear datfilenamebase date expnum1 expnum2 count k l

%% Move to the MATLAB folder
cd(RecInfo.MatlabFolder)

%% Move to the Data folder
cd(RecInfo.DataFolder)

%% dat file pre-processing
[ flag ] = lfpprepf_Takeuchi3_dual_Template1( RecInfo );
% [ flag ] = lfpprepf_Takeuchi3_dual_500Hz_Template1( RecInfo );
% [flag] = lfpprepf_Takeuchi3_Template1( RecInfo );
% [flag] = lfpprepf_Takeuchi3_500Hz_Template1( RecInfo );
clear flag

%% Get timestamps from a digital channel and build a data structure
% Get timestamp cell vector from each digital channel .dat file
[ TSCellVector ] = digchf_dig2TimestampCellVector1( RecInfo.datString, 0.1, RecInfo.srLFP);

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

%% Copy this script to the data folder
cd(RecInfo.MatlabFolder)
copyfile([RecInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_SeizureDrtn1.m'],...
    [RecInfo.DataFolder '\eplpsys_SeizureDrtn1.m']);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [RecInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_SeizureDrtn1.m'],...
    RecInfo.DataFolder);
clear flag
cd(RecInfo.DataFolder)
