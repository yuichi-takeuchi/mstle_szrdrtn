function [ flag ] = eplpsyf_FiltStdDrtn1( DataStruct, Params, RecInfo, FigFlag )
%
% This function is used to detect durations of hippocampal and cortical
% seizures. Outputs are csv files
%
% INPUTS:
%       DataStruct.datafilenamebase: e.g. 'AP_180815_exp02_01'
%       DataStruct.datfilename: Cell vector of datfilename as {'AP_180815_exp02_01_1_LFP_reorg.dat','AP_180815_exp02_01_2_LFP_reorg.dat'}
%       DataStruct.Timestamp: Cell vector of timestamps from a 4 bit digital
%       channel.
%       Params.sr: samplirng rate (in Hz)
%       Params.TSbit: samplirng rate (in Hz)
%       Params.nChannel: total number of channel of each rat
%       Params.ChLabel: ChLable like {'MEC' 'RHPC' 'LCHP' 'Ctx'}
%       Params.ChOrder: Cell for channel vector
%       Prams.BaselineDrtn: e.g. 30 s baseline before stimulation
%       Params.TestDrtn: e.g. 180 s test period after stimulation
%       Params.HighPassLim: in Hz
%       Params.LowPassLim: in Hz
%       RecInfo.LTR: Vector of rat number
%       RecInfo.expnum1, expnum2: Experimental ID
%       FigFlag: true for print
%
% OUTPUTS:
%       csv file for seizure duration
%     
% Copyright (C) 2018 Yuichi Takeuchi
%
sr = Params.sr;
TSbit = Params.TSbit;
nChannel = Params.nChannel; 
ChLabel = Params.ChLabel;
ChOrder = Params.ChOrder;
BaselineDrtn = Params.BaselineDrtn;
TestDrtn = Params.TestDrtn;
CoeffStd = Params.CoeffStd; % CoeffStd for MEC, RHPC, LCHP, Ctx
HighPassLim = Params.HighPassLim;
LowPassLim = Params.LowPassLim;

for DataNo = 1:length(DataStruct)
    Data = DataStruct(DataNo);
    Timestamp = Data.Timestamp;
    datfilenameVec = Data.datfilename;
    for RatNo = 1:length(datfilenameVec)
        LTR = [];
        Date = [];
        expNo1 = [];
        expNo2 = [];
        ADDrtn = [];
        sGSDrtn = [];
        TotalDrtn = [];
        for TrialNo = 1:size(Timestamp{1,TSbit},1)
            % Data access
            datfilename = Data.datfilename{RatNo};
            m = memmapfile(datfilename,'format','int16');
            d = reshape(m.data, nChannel, []);
            TS = Timestamp{1,TSbit}(TrialNo,:);
            segData = d(:, (TS(1)-BaselineDrtn):(TS(1)+TestDrtn));
            
            % Filtering
%             [segFltrdTemp] = filtf_HighPassButter3(segData, HighPassLim, 3, sr); % [DataOut] = filtf_HighPassButter3(DataIn, highpasscutoff, highpassorder, fs)
%             [segFltrd] = filtf_LowPassButter3(segFltrdTemp, LowPassLim, 3, sr);% [DataOut] = filtf_LowPassButter3(DataIn, lowpasscutoff, lowpassorder, fs)
            segFltrd = double(segData);
            
            % Calculation of standard deviation of each region
            Std = std(segFltrd(:,1:BaselineDrtn), 0, 2)';

            % Conditioning
            condData = segFltrd;
            condData(:) = false; % initialization
            for i = 1:numel(ChLabel)
                for Ch = ChOrder{i}
                    condData(Ch,:) = segFltrd(Ch,:) > Std(Ch)*CoeffStd(i);
                end
            end

            % Regional conditioning summary
            for j = numel(ChOrder):-1:1
                AllIndex{j} = any(condData(ChOrder{j},:));
            end
            
            if(FigFlag)
                Title = [RecInfo.stringCellVector{DataNo} '_' num2str(RatNo) '_' num2str(TrialNo)];
                [ hstruct ] = eplpsyf_DetectionCheckFig1( segFltrd, AllIndex, ChLabel, ChOrder, Std, CoeffStd, sr,Title);
%                 print([RecInfo.stringCellVector{DataNo} '_' num2str(RatNo) '_' num2str(TrialNo) '.pdf'], '-dpdf');
                print(['DtctnFltStd_' Title '.png'], '-dpng');
                close(hstruct.hfig)
            end
            
            %%% Determination of seizure duraiton
            for i = numel(ChLabel):-1:1
                [~,tempR,tempF] = ssf_FindConsecutiveTrueChunks(AllIndex{i});
                tempR = tempR(tempR > BaselineDrtn + uint64(floor(2*sr)));
                tempF = tempF(tempR > BaselineDrtn + uint64(floor(2*sr)));
                % algorithm
                RFMatrix(i,:) = uint64([tempR(1) tempF(end)]);
            %     tempRF = uint64([tempR' tempF']);
            end
            
            LogicalVector = 1:size(segData,2);
%             MEMLogicalVec = LogicalVector > RFMatrix(1,1) & LogicalVector < RFMatrix(1,2);
            RHPCLogicalVec = LogicalVector > RFMatrix(2,1) & LogicalVector < RFMatrix(2,2);
            LHPCLogicalVec = LogicalVector > RFMatrix(3,1) & LogicalVector < RFMatrix(3,2);
            CtxLogicalVec = LogicalVector > RFMatrix(4,1) & LogicalVector < RFMatrix(4,2);
            HPCLogicalVec = RHPCLogicalVec & LHPCLogicalVec;
            ADLogicalVec = ((LogicalVector > RFMatrix(2,1) & LogicalVector < RFMatrix(2,2)) | (LogicalVector > RFMatrix(3,1) & LogicalVector < RFMatrix(3,2))) & LogicalVector < RFMatrix(4,1);
            ADDrtntemp = nnz(ADLogicalVec)/sr;
            HPCDrtn = nnz(HPCLogicalVec)/sr;
            CtxDrtn = nnz(CtxLogicalVec)/sr;
            
            %%% Data collection into a summary table
            LTR = [LTR; RecInfo.LTR(RatNo)];
            Date = [Date; RecInfo.date];
            expNo1 = [expNo1; RecInfo.expnum1];
            expNo2 = [expNo2; RecInfo.expnum2];
            ADDrtn = [ADDrtn; ADDrtntemp];
            sGSDrtn = [sGSDrtn; CtxDrtn];
            TotalDrtn = [TotalDrtn; HPCDrtn];
        end
        
        % Write a summary csv file
        Tb = table(LTR, Date, expNo1, expNo2, ADDrtn,  sGSDrtn, TotalDrtn);
        Tb.Properties.VariableNames = {'LTR' 'Data' 'expNo1' 'expNo2' 'ADDrtn' 'sGSDrtn' 'TotalDrtn'};
        writetable(Tb, [RecInfo.stringCellVector{DataNo} '_' num2str(RatNo) '.csv']);
    end
end

flag = 1;

