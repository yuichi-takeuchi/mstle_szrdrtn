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



end
