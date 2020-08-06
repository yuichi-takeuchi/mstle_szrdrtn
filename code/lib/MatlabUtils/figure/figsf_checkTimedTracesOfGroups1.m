function [ flag ] = figsf_checkTimedTracesOfGroups1( RecInfo, DataStruct, cParams)
%
% Copyright (C) Yuichi Takeuchi 2018

disp('processing...');tic
flag = 0;
for DataNo = 1:length(DataStruct)
    Data = DataStruct(DataNo);
    for RatNo = 1:length(Data.datfilename)
        % dat file data access
        datfilename = Data.datfilename{RatNo};
        for TrialNo = 1:size(Data.Timestamp{1,cParams.TSbit},1)
            % Cut the data and remove the stimulus artifact
            TS = Data.Timestamp{1,cParams.TSbit}(TrialNo,:);
            Segment = [TS(1)-cParams.BaselineDrtn, TS(1)+cParams.TestDrtn];
            [ segData ] = fileiof_getSegmentFromBinary1( datfilename, Segment, cParams.nChannel );
            segData(:, [30*RecInfo.srLFP:(32*RecInfo.srLFP - 1)]) = 0;
            [ segDatasc ] = apf_ScaleUnitV( segData,  400, 16, 10, 1e3); % scaling to mV
            t = 0:1/cParams.sr:(size(segDatasc,2)-1)/cParams.sr;
            
            % figure
            fignum = 1;
            [ hs ] = figf_VoltageTracesOfSubGroups1( t, segDatasc, cParams.ChOrder, cParams.ChLabel, fignum);
            
            % figure title
            Title = [RecInfo.datString{DataNo} '_Rat' num2str(RecInfo.LTR(RatNo)) '_Trial' num2str(TrialNo)];
            reptitle = strrep(Title, '_', '-');
            axes; htitle = title(reptitle); axis off;
            
            % Figure output
            set(gcf,'Renderer','Painters');
            print(['Traces_' Title '.pdf'], '-dpdf');
            print(['Traces_' Title '.png'], '-dpng');
            close gcf
        end
    end
end
flag = 1;
disp('done');toc
