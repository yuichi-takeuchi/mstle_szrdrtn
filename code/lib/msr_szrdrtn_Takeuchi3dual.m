function msr_szrdrtn_Takeuchi3dual()
% This routine analyses HPC and Ctx seizure durations and provides an comma
% separated value file as output
% Copyright (C) 2018–2020 Yuichi Takeuchi

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

%% dat file pre-processing
[ flag ] = lfpprepf_Takeuchi3_dual_Template1( RecInfo );
% [ flag ] = lfpprepf_Takeuchi3_dual_500Hz_Template1( RecInfo );
% [flag] = lfpprepf_Takeuchi3_Template1( RecInfo );
% [flag] = lfpprepf_Takeuchi3_500Hz_Template1( RecInfo );
clear flag


