function [hstruct] = csdf_CSDimage1(DataCSD,sr,nChannels,TimeScale,fignum)
%
% INPUTS:
%       DataCSD: Time series x Channels
%       sr: sampling rate
%       nChannels: number of Channels (includes the first and the last)
%       TimeScale: TimeScale for interp2
%       fignum: figure number (integer)
%
% Copyright (c) 2016 Yuichi Takeuchi

hfig = figure(fignum);
timecourse = [0 (length(DataCSD)-1)]/sr*TimeScale;
Channels = 2:nChannels-1;
XChannels = [1 nChannels-1];
DataCSDinv = DataCSD';
clims = [-0.07 0.07];
him = imagesc(timecourse, XChannels, DataCSDinv, clims);
haxes = gca;
hold(haxes,'on');
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
    'PaperPosition', [7 7 12 12],...
    'NumberTitle','on'...
    );
%     'Name','Amplitude of Spectrum'...

 set(him,...
     'CDataMapping','scaled'...
     );

hcb.Label.String = 'source  -  sink  (V/mm^2)';

ChannelLabel = int2str(Channels');
set(haxes,...
    'Layer', 'top',...
    'YLim',[1 nChannels-1],...
    'YTick',[2-0.5:(nChannels-1-0.5)],...
    'YTickLabel', ChannelLabel,...
    'TickLength', [0.005;0],...
    'TickDir', 'out',...
    'Ydir','reverse',...
    'FontName', fontname,...
    'FontSize', fontsize...
    );
%     'XTick', [],...

hstruct.hfig = hfig;
hstruct.him = him;
hstruct.hcm = hcm;
hstruct.hcb = hcb;
hstruct.haxes = haxes;
hstruct.hxlabel = hxlabel;
%hstruct.hylabel = hylabel;
hstruct.htitle = htitle;