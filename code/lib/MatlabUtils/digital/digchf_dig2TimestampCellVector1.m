function [ TSCellVector ] = digchf_dig2TimestampCellVector1( datString, minSegDrtn, sr)
%
% [ TSCellVector ] = digchf_dig2TimestampCellVector1( datString, minSegDrtn, sr)
%
% INPUTS:
%       datString: String vector, e.g. [ "AP_180815_exp01_01"
%       "AP_180815_exp01_02"    "AP_180815_exp02_01"]
%       minSegDrtn: minimam segment duration for rejection (in second)
%       sr: samplirng rate (in Hz)
%
% OUTPUTS:
%       Cell vector of timestamp cell array of 1st to 4th bit
%       matfile of each datfile
%     
% Copyright (C) 2018, 2020 Yuichi Takeuchi
%
TSCellVector = cell(1,numel(datString));

for i = 1:numel(datString)
    digdatfilename = [datString{i} '_dig.dat'];
%    disp(['processing ' digdatfilename '...']); tic
    
    % Memory mapping
    mdig = memmapfile(digdatfilename, 'format', 'int16');
    digch = mdig.data';
    
    % Getting timestamps for rising and falling of each bit of digital channel
    [ TSCell ] = digchf_dig2TimestampCell1( digch );
    
    % Conditioning by segment length
    for k = 1:length(TSCell)
        tempTS = TSCell{k};
        for j = size(tempTS,1):-1:1
            SegDrtn = double((tempTS(j,2) - tempTS(j,1)))/sr;
            if (SegDrtn < minSegDrtn)
                TSCell{k}(j,:) = [];
            end
        end
    end
    
    % Output variable
    TSCellVector{i} = TSCell;
    
%     % Save mat file
%     save([datString{i} '_Timestamp.mat'], 'TSCellVector','-v7.3')
%     disp('done');toc
end


