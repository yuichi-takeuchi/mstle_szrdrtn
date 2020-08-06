function [ flag ] = eplpsyf_detectEvokedSeizureBPFltMvmnRMSThrshld1( RecInfo, DataStruct, cParams, figFlag, tbFlag)
%
% Copyright (C) 2018 Yuichi Takeuchi

% Setting parameters
rmsCoeff = [3 3 3 3]; % CoeffStd for MEC, RHPC, LCHP, Ctx
HighPassLim = 10;
LowPassLim = 80;

% Main procedure
disp('start analysis...');tic
flag = 0;
for DataNo = 1:length(DataStruct)
    Data = DataStruct(DataNo);
    Timestamp = Data.Timestamp;
    datfilenameVec = Data.datfilename;
    for RatNo = 1:length(datfilenameVec)
        datfilename = Data.datfilename{RatNo};
         for TrialNo = 1:size(Timestamp{1,cParams.TSbit},1) % TrialNo = 1:size(Timestamp{1,cParams.TSbit},1)-1
            % Data access, extraction of a period
            TS = Timestamp{1,cParams.TSbit}(TrialNo,:);
            Segment = [TS(1)-cParams.BaselineDrtn, TS(1)+cParams.TestDrtn];
            [ segData ] = fileiof_getSegmentFromBinary1( datfilename, Segment, cParams.nChannel );
            segData(:, [(cParams.BaselineDrtn):(cParams.BaselineDrtn+2*cParams.sr-1)]) = 0; % Removal of stimulus artifact
                        
            %%% Singal pre-processing
            % Band-pass filt
            [segFltrdTemp] = filtf_HighPassButter3(segData, HighPassLim, 3, cParams.sr); % [DataOut] = filtf_HighPassButter3(DataIn, highpasscutoff, highpassorder, fs)
            [segFltrd] = filtf_LowPassButter3(segFltrdTemp, LowPassLim, 3, cParams.sr);% [DataOut] = filtf_LowPassButter3(DataIn, lowpasscutoff, lowpassorder, fs)

            % Rectification
            segRectified = abs(segFltrd);

            % Zero-lag moving mean filter
            movmeanCoeff = ones(1,3*cParams.sr)/(3*cParams.sr);
            segSmthd = filtfilt(movmeanCoeff, 1, segRectified(1:30,:)'); segSmthd = segSmthd';

            % rms thresholding
            Rms = rms(segSmthd(:,1:cParams.BaselineDrtn), 2);
            thrshldd = false(size(segSmthd)); % initialization
            for i = 1:numel(cParams.ChLabel)
                for j = cParams.ChOrder{i}
                    thrshldd(j,:) = segSmthd(j,:) > Rms(j)*rmsCoeff(i);
                end
            end
            
             % Logical summary on each brain resion (algorithm)
            logicSum = false(numel(cParams.ChLabel), size(thrshldd,2));
            for i = 1:numel(cParams.ChLabel)
                logicSum(i,:) = any(thrshldd(cParams.ChOrder{i},:)); % need all
            end
            
            % Getting timestamps of rising and falling of logic matrix with
            % rejection before stimulation
            rcjctMat = [1, cParams.BaselineDrtn+uint64(floor(2*cParams.sr))]; % from the begining to the end of stimulation
            [ RiseFallCellVec ] = logicf_getTimestampCellVec1( logicSum, rcjctMat );

%             % Algorithm for time-stamp rejection
%             for i = length(RiseFallCellVec):-1:1
%                 [ rjctIndex1{i} ] = tsf_getRejectionIndexByIntervalConditioning1( RiseFallCellVec{i}, 3, cParams.sr, true);
%                 [ rjctIndex2{i} ] = tsf_getRejectionIndexByIntervalConditioning1( RiseFallCellVec{i}, 3, cParams.sr, false);
%                 [C,~,~] = intersect(rjctIndex1{i}, rjctIndex2{i}+1);
%                 if ~isempty(C)
%                     RiseFallCellVec{i}(C(1):end,:) = [];
%                 end
%             end
            
            % Logical calcuration of seizures
            LogicalVec = logicSum;
            HPCLogicalVec = LogicalVec(2,:) & LogicalVec(3,:); 
            CtxLogicalVec = LogicalVec(4,:);
            if(~isempty(RiseFallCellVec{4}))
                ADLogicalVec = (LogicalVec(2,:) | LogicalVec(3,:)) & (1:size(logicSum,2) < RiseFallCellVec{4}(1,1));
            else
                ADLogicalVec = false(1,size(LogicalVec,2));
            end

            % Data collection into a summary table
            ADDrtn(TrialNo,1) = nnz(ADLogicalVec)/cParams.sr;
            HPCDrtn(TrialNo,1) = nnz(HPCLogicalVec)/cParams.sr;
            CtxDrtn(TrialNo,1) = nnz(CtxLogicalVec)/cParams.sr;
            
            % Figure export 
            if(figFlag)
                Title = [RecInfo.datString{DataNo} '_Rat' num2str(RatNo) '_Trial' num2str(TrialNo)];
                [ hs ] = eplpsyf_DetectionCheckFig2( segFltrd, segSmthd, LogicalVec, cParams.ChLabel, cParams.ChOrder, Rms, rmsCoeff, cParams.sr, Title);
                print(['DtctnFltStd_' Title '.png'], '-dpng');
                set(gcf,'Renderer','Painters');
                print(['DtctnFltStd_' Title '.pdf'], '-dpdf');

                close(gcf)
            end
        end
      
        % Write a summary csv file
        LTR = repmat(RecInfo.LTR(RatNo), size(Timestamp{1,cParams.TSbit},1), 1);
        Date = repmat(RecInfo.date, size(Timestamp{1,cParams.TSbit},1), 1);
        expNo1 = repmat(RecInfo.expnum1, size(Timestamp{1,cParams.TSbit},1), 1);
        expNo2 = repmat(RecInfo.expnum2, size(Timestamp{1,cParams.TSbit},1), 1);
%         LTR = repmat(RecInfo.LTR(RatNo), size(Timestamp{1,cParams.TSbit},1)-1, 1);% !! minus 1 modified
%         Date = repmat(RecInfo.date, size(Timestamp{1,cParams.TSbit},1)-1, 1);% !! minus 1 modified
%         expNo1 = repmat(RecInfo.expnum1, size(Timestamp{1,cParams.TSbit},1)-1, 1);% !! minus 1 modified
%         expNo2 = repmat(RecInfo.expnum2, size(Timestamp{1,cParams.TSbit},1)-1, 1);% !! minus 1 modified
        
        % csv output
        if tbFlag
            Tb = table(LTR, Date, expNo1, expNo2, ADDrtn,  HPCDrtn, CtxDrtn);
            Tb.Properties.VariableNames = {'LTR' 'Data' 'expNo1' 'expNo2' 'ADDrtn' 'HPCDrtn' 'CtxDrtn'};
            writetable(Tb, [RecInfo.datString{DataNo} '_' num2str(RatNo) '.csv']);
        end
    end
end
flag = 1;
disp('done');toc



