function [hstruct] = unf_WaveformPlot(Waveforms, CluVec, ClusterID)
%
% Usage: unf_WavePlot plots Waveforms of Cluster
%
% INPUTS:
%    Waveforms: Matrix (ch x Datapoint x spike)
%    CluVec:    Vector like .clu.0 file but without total no. cluster
%    ClusterID: Cluster No. (scalar or Vector)
%
% Copyright (C) 2016, 2017 Yuichi Takeuchi
%


% Parameters
fontname = 'Arial';
fontsize = 8;

nChannels = size(Waveforms, 1);
tic
h = waitbar(0,'Waveform plot...');
counter = 1;
for k = ClusterID
    waitbar(counter/length(ClusterID));
    % making figure
    hfig = figure(k);
    set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [7 7 12 9],...
    'NumberTitle','off',...
    'Name',['Cluster ' num2str(k)]...
    );

    index = find(CluVec == k);
    if length(index) > 100
       index = index(1:100); 
    end

    % making subplot
    for m = 1:nChannels
        % subplot 5 in one column
        haxes = subplot(ceil(nChannels/5),5,m);
        hold(haxes,'on');
        set(haxes,...
            'XTick', [],...
            'XTickLabel', [],...
            'YLim',[-300,300],...
            'YTick',[],...
            'YTickLabel', [],...
            'FontName', fontname,...
            'FontSize', fontsize...
            );
        
        htitle = title(['Ch ',num2str(m)]);
        
        % plotting waves
        for n = 1:length(index)
             Wave = Waveforms(:,:,index(n));
             Plotdata = Wave(m,:);
             plot(haxes, Plotdata,'k', 'LineWidth',0.25);
        end
    end
    hold(haxes,'off');
    counter = counter + 1;
end

hstruct.hfig = hfig;
hstruct.haxes = haxes;
% hstruct.hxlabel = hxlabel;
% hstruct.hylabel = hylabel;
hstruct.htitle = htitle;

% Finishing info
close(h)
toc

