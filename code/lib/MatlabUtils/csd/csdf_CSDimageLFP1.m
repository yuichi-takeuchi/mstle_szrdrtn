function [hstruct] = csdf_CSDimageLFP1(DataCSD,DataLFP,scalingfactor,sr,fignum)
%
% csdf_CSDimageLFP1 plots CSD image and LFP plots on it.
%
% INPUTS:
%       DataCSD: Time series x Channels (2:nChannels -1)
%       DataLFP: Time series x Channels (1:nChannels)
%       scalingfactor: Scaling for display
%       sr: sampling rate
%       fignum: figure number (integer)
%
% Copyright (c) 2016 Yuichi Takeuchi

hfig = figure(fignum);
timecourse = [0 size(DataLFP,1)/sr];
nChannels = size(DataLFP,2);
Channels = 1:nChannels;
XChannels = [1 nChannels-1];
DataCSDinv = DataCSD';
clims = [-0.07 0.07];
him = imagesc(timecourse, XChannels, DataCSDinv, clims);
haxes = gca;
hold(haxes,'on');
xwave = linspace(0, size(DataLFP,1)/sr, size(DataLFP,1));
DataLFP = DataLFP*scalingfactor;

for k = Channels %Channels
    SrcWave = DataLFP(:,k);
    SrcWave = -SrcWave + k -0.5;
    hline(k).h = plot(xwave, SrcWave, 'k', 'LineWidth', 0.3);
end

hxlabel = xlabel('Time (s)');
hylabel = ylabel('Channel');
htitle = title('Current Source Density');
hcm = colormap('jet');
hcb = colorbar;
hold(haxes,'off');

% Parameters
fontname = 'Arial';
fontsize = 8;

set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [7 7 12 16],...
    'NumberTitle','on'...
    );
%     'Name','Amplitude of Spectrum'...

% set(him,...
%      'CDataMapping','scaled'...
%      );

hcb.Label.String = 'source  -  sink  (V/mm^2)';

ChannelLabel = int2str(Channels');
set(haxes,...
    'XLim', [0 10],...
    'YLim',[0 nChannels],...
    'YTick',[1-0.5:(nChannels-0.5)],...
    'YTickLabel', ChannelLabel,...
    'TickLength', [0.005;0],...
    'TickDir', 'out',...
    'Ydir','reverse',...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

%     'XTick', [],...
%     'Layer', 'top',...

hstruct.hfig = hfig;
hstruct.him = him;
hstruct.hcm = hcm;
hstruct.hcb = hcb;
hstruct.haxes = haxes;
hstruct.hline = hline;
hstruct.hxlabel = hxlabel;
hstruct.hylabel = hylabel;
hstruct.htitle = htitle;