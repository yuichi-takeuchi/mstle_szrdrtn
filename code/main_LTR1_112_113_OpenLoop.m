%% mstle_msr_szrdrtn
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% metainfo
%%
metainfo = {
    'AP', 190812, [112 113]; % camkiia-ChR2, open-loop intervention
    'AP', 190813, [112 113];
    'AP', 190814, [112 113];
    };
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% Downsampling and channel reorganization
%%
for i = 1:size(metainfo,1)
    ds_Takeuchi3dual_dig_to_1250(metainfo{i,1}, metainfo{i,2})
end
clear i
%% Get timestamps of seizure induction
%%
RecInfo = cell(1, size(metainfo,1));
DataStruct = cell(1, size(metainfo,1));
for i = 1:size(metainfo,1)
    [tmpRecInfo] = getRecInfo(1, 1, metainfo{i,2}, metainfo{i,3}, 1250);
    [tmpDataStruct] = getDataStruct(tmpRecInfo);
    RecInfo{i} = tmpRecInfo;
    DataStruct{i} = tmpDataStruct;
end
clear i tmpRecInfo tmpDataStruct
%% Manual curation of timestamp (optional)
%%
ind1 = 1;
ind2 = 1;
index = [6];
DataStruct{1,ind1}(ind2).Timestamp{1, 1}(index,:) = [];
DataStruct{1,ind1}(ind2).TimestampMin(index,:) = [];
save(['tmp/' RecInfo{ind1}.datfilenamebase '_exp' num2str(RecInfo{ind1}.expnum1) '_' num2str(RecInfo{ind1}.expnum2) '_DataStruct.mat'], 'DataStruct')
clear ind1 ind2 index
%% measurment of seizure duration
%%
for i = 1:size(metainfo,1)
    [flag] = msr_szrdrtn_Takeuchi3(RecInfo{i}, DataStruct{i});
end
clear i flag