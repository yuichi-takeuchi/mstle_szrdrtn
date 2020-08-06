function [ flag ] = figsf_evokedTFSpctrgrmChrouxSurf1( RecInfo, DataStruct, cParams, params, movingwin )
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
            
            % multi-taper spectrum analysis
            [S,t,f,~] = mtspecgramc(double(segData'),movingwin,params);
            
            % Normlize power (whitening)
            S = S.*repmat(f, size(S, 1), 1, size(S,3));
            
            % figure
            fignum = 1;
            hfig = figure(fignum);
            set(hfig,...
                'PaperUnits', 'centimeters',...
                'PaperPosition', [0.5 0.5 16 12],... % [h distance, v distance, width, height], origin: left lower corner
                'PaperSize', [17 13]); % width, height
            
            p = ceil(sqrt(cParams.nChannel));
            colorRes = 2^8;
            for ChNo = 1:cParams.nChannel
                hax = subplot(p,p,ChNo);
                
                % linear normalization by max value over whole frequencies
                srcS = S(:,:,ChNo)';
                scldS = colorRes*abs(srcS)/max(abs(srcS(:)));

                % surface plot
                [ hs ] = plotf_TimeFreqSurfPlot1( t, f, scldS, fignum, hax, colorRes, 4 );
                set(hax,...
                    'FontName', 'Arial',...
                    'FontSize', 6);
                
                % patch for stimulation timing
                hptch = patch(hax,[30 32 32 30],[f(1) f(1) f(end) f(end)],'w');
                set(hptch,...
                    'EdgeColor', 'none');
            end

            % figure title
            Title = [RecInfo.datString{DataNo} '_Rat' num2str(RecInfo.LTR(RatNo)) '_Trial' num2str(TrialNo)];
            reptitle = strrep(Title, '_', '-');
            axes; htitle = title(reptitle); axis off;
            
            % Figure output
%             set(hfig, 'Renderer','Painters');
%             print(['MTTFSpctgrm_' Title '.pdf'], '-dpdf');
            print(['MTTFSpctgrm_' Title '.png'], '-dpng');
            close gcf
        end
    end
end
flag = 1;
disp('done');toc


