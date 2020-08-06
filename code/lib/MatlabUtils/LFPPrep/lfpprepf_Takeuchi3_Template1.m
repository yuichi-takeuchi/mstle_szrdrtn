function [ flag ] = lfpprepf_Takeuchi3_Template1( RecInfo )
%
% [ flag ] = lfpprepf_Takeuchi3_500Hz_Template1( input_args )
%
% This function conducts pre-processing of dat files including DC removal,
% low- and high-pass filtering, adc and digital channel extractions
%
% INPUTS:
%   RecInfo structure must include the following field
%     RecInfo = struct(...
%         'expnum1', [1 2],...
%         'expnum2', [1:3],...
%         'datfilenamebase', 'AP_180815_exp',...
%         'matfilenamebase', 'AP_180815_exp_DatPrep_Template1',...
%         'nChannels', 32,...
%         'sr', 20000,...
%         'srLFP', 500,...
%         'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
%         'DataFolder', ['D:\Research\Data\LongTermRec1\LTRec1_85_86\180815']...
%         );
%
% Copyright (C) Yuichi Takeuchi 2017, 2018
%

% Copy Template folder structure
copyfile([RecInfo.MatlabFolder '\Yuichi\LFPPrep\template\Takeuchi3'],RecInfo.DataFolder)

% Dat file preparations
disp('dat file preparations...');tic
for k = RecInfo.expnum1
    for l = RecInfo.expnum2
        datfilenamebase = [RecInfo.datfilenamebase num2str(k) '_' num2str(l)];
        if(exist([datfilenamebase '.dat'],'file'))
            disp(['processing ' datfilenamebase '.dat'])
            [ flag ] = lfpprepf_Takeuchi3_with1A1D( datfilenamebase,  RecInfo.sr, RecInfo.srLFP, RecInfo.nChannels);
            movefile([datfilenamebase '_LFP_reorg.dat'], [RecInfo.datfilenamebase num2str(k,'%02.f') '_' num2str(l,'%02.f') '_1_LFP_reorg.dat']); % renaming
            movefile([datfilenamebase '_adc.dat'], [RecInfo.datfilenamebase num2str(k,'%02.f') '_' num2str(l,'%02.f') '_1_adc.dat']); % renaming
            movefile([datfilenamebase '_dig.dat'], [RecInfo.datfilenamebase num2str(k,'%02.f') '_' num2str(l,'%02.f') '_dig.dat']); % renaming
        end
    end
end
disp('done'); toc

% move raw data files
for k = RecInfo.expnum1
    for l = RecInfo.expnum2
        datfilename = [RecInfo.datfilenamebase num2str(k) '_' num2str(l) '.dat'];
        inifilename = [RecInfo.datfilenamebase num2str(k) '_' num2str(l) '.ini'];
        metafilename = [RecInfo.datfilenamebase num2str(k) '_' num2str(l) '.meta'];
        evtfilename = [RecInfo.datfilenamebase num2str(k) '_' num2str(l) '.dig.evt'];
        mpgfilename = [RecInfo.datfilenamebase num2str(k) '_' num2str(l) '.mpg'];
        tspfilename = [RecInfo.datfilenamebase num2str(k) '_' num2str(l) '.tsp'];
        copydirectoryname = 'raw_data';
        if(exist(datfilename,'file'))
             movefile(datfilename, copydirectoryname);
        end
        if(exist(inifilename,'file'))
             movefile(inifilename, copydirectoryname);
        end
        if(exist(inifilename,'file'))
             movefile(inifilename, copydirectoryname);
        end
        if(exist(metafilename,'file'))
             movefile(metafilename, copydirectoryname);
        end
        if(exist(evtfilename,'file'))
             movefile(evtfilename, copydirectoryname);
        end
        if(exist(mpgfilename,'file'))
             movefile(mpgfilename, copydirectoryname);
        end
        if(exist(tspfilename,'file'))
             movefile(tspfilename, copydirectoryname);
        end
    end
end

flag = 1;


