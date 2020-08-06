function [ flag ] = figsf_evokedScalogramSurf1( RecInfo, DataStruct, DataNo, RatNo, TrialNo, ChNo, cParams )
%
% Copyright (C) Yuichi Takeuchi 2018

flag = 0;
hwb = waitbar(0,'wavelet analysis...');
count = 0;
for DataNo = DataNo % = 1:length(DataStruct)
    count = 1+ count;
    waitbar(count/numel(DataNo), hwb)
    Data = DataStruct(DataNo);
    for RatNo = RatNo % = 1:length(datfilename)
        % Data access
        datfilename = Data.datfilename{RatNo};
        disp(['Analizing ' datfilename '...']); tic
        for TrialNo = TrialNo % = 1:size(Data.Timestamp{1,cParams.TSbit},1)
            % Access to a trial; cut the data and remove the stimulus artifact
            TS = Data.Timestamp{1,cParams.TSbit}(TrialNo,:);
            Segment = [TS(1)-cParams.BaselineDrtn, TS(1)+cParams.TestDrtn];
            [ segData ] = fileiof_getSegmentFromBinary1( datfilename, Segment, cParams.nChannel );
            segData(:, [30*RecInfo.srLFP:(32*RecInfo.srLFP - 1)]) = 0;
            
            % figure
            fignum = 1;
            hfig = figure(fignum);
            set(hfig,...
                'PaperUnits', 'centimeters',...
                'PaperPosition', [0.5 0.5 16 12],... % [h distance, v distance, width, height], origin: left lower corner
                'PaperSize', [17 13]); % width, height
                
            colorRes = 2^8;
            for ChNo = ChNo %= 1:cParams.nChannel
                %wavelet analysis
                [ scldwt, f, t ] = cwtf_PowerGlobalNormalization1( double(segData(ChNo,:)), RecInfo.srLFP, colorRes );
                
                % Getting an axis handle
                hax = axes;

                % surface plot
                [ hs ] = plotf_TimeFreqSurfPlot1( t, f, scldwt, fignum, hax, colorRes, 4);
                set(get(hax, 'XLabel'),...
                    'String', 'Time (s)');
                set(get(hax, 'YLabel'),...
                    'String', 'Frequency (Hz)');
                set(hax,...
                    'XLim', [0 210],...
                    'YLim', [1 100],...
                    'FontName', 'Arial',...
                    'FontSize', 8);
                                    
                % patch for stimulation timing
                hptch = patch(hax,[30 32 32 30],[1 1 100 100],'w');
                set(hptch,...
                    'EdgeColor', 'none');
                
                % figure title
                Title = [RecInfo.datString{DataNo} '_Rat' num2str(RecInfo.LTR(RatNo)) '_Trial' num2str(TrialNo) '_ch' num2str(ChNo)];
                reptitle = strrep(Title, '_', '-');
                axes; htitle = title(reptitle); axis off;

                % Figure output
%                 set(hfig,'Renderer','Painters');
%                 print(['Scalogram_' Title '.pdf'], '-dpdf');
                print(['Scalogram_' Title '.png'], '-dpng');
                close gcf
            end
        end
    end
end
close(hwb)
disp('done');toc
flag = 1;
