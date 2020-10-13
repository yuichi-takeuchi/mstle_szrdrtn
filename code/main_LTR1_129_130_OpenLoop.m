%% mstle_msr_szrdrtn
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% metainfo
%%
ID = 'LTR1_129_130';
closed = 0; % 0 and 1 for open-loop and closed-loop control
metainfo = {
    'AP', 200817, 2, 1, [129 130];
    'AP', 200817, 2, 2, [129 130];
    'AP', 200819, 3, 1, [129 130];
    'AP', 200819, 3, 2, [129 130];
    };
%% Downsampling and channel reorganization
%%
for i = 1:size(metainfo,1)
    ds_Takeuchi3dual_2A1D_20k_to_500(metainfo{i,1}, metainfo{i,2}, metainfo{i,3}, metainfo{i,4})
end
clear i
%% Get timestamps of seizure induction (digital channel bit 0)
%%
% get timestamps of seizure induction, detections of rat 1, rat 2
[RecInfo,DataStruct] = getTspSeizureInduction2(metainfo, ID, closed);
%% Manual curation of timestamp
%%
load(['tmp/' ID '_' num2str(closed) '_RecInfo.mat' ], 'RecInfo')
load(['tmp/' ID '_' num2str(closed) '_DataStruct.mat'], 'DataStruct')
cidx = {
    1, 1, [7 8], repmat([1 1],1,3); % record num of metainfo, rat No, rejection trial no, trues for trials to be analyzed
    1, 2, [7 8], repmat([1 1],1,3);
    2, 1, [], repmat([1 1],1,4); % record num of metainfo, rat No, rejection trial no, trues for trials to be analyzed
    2, 2, [], repmat([1 1],1,4);
    3, 1, [], repmat([1 1],1,4); % record num of metainfo, rat No, rejection trial no, trues for trials to be analyzed
    3, 2, [], repmat([1 1],1,4);
    4, 1, [], repmat([1 1],1,4); % record num of metainfo, rat No, rejection trial no, trues for trials to be analyzed
    4, 2, [], repmat([1 1],1,4);
    };
for i = 1:size(cidx, 1)
    DataStruct{1,cidx{i,1}}(cidx{i,2}).Timestamp{1, 1}(cidx{i,3},:) = [];
    DataStruct{1,cidx{i,1}}(cidx{i,2}).TimestampMin(cidx{i,3},:) = [];
    DataStruct{1,cidx{i,1}}(cidx{i,2}).idxslct = cidx{i,4};
end
save(['tmp/' ID '_' num2str(closed) '_DataStruct_curated.mat'], 'DataStruct')
clear cidx i
%% measurment of seizure duration
%%
for i = 1:size(metainfo,1)
    [flag] = msr_szrdrtn_Takeuchi3(RecInfo{i}, DataStruct{i});
end
clear i flag
%% Trial file extraction for manual curation
%%
for i = 1:size(metainfo,1)
    [flag] = cut_postInductionTime_Takeuchi3_dual(RecInfo{i}, DataStruct{i}, closed);
end
disp('trial extraction done')
clear i flag