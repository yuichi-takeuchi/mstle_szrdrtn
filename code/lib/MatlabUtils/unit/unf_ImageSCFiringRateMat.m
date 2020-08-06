function [ hstruct ] = unf_ImageSCFiringRateMat( FiringRateMat,Clims,CluID,fignum )
%
% unf_ImageSCFiringRateMat plots Firing rate along time course.
%
% INPUTS:
%    FiringRateMat: timeseries x clusters x firing rate
%    CluID = ID of Clusters, scalar or vector
%    Clims = limits of color maps
%    fignum: figuerID (integer)
%
% Copyright (C) 2016 Yuichi Takeuchi
%

hfig = figure(fignum);
if isempty(Clims)
    him = imagesc(FiringRateMat');
else
    him = imagesc(FiringRateMat',Clims);
end
haxes = gca;
%axes('Parent',hfig);
hold(haxes,'on');
hxlabel = xlabel('Time (s)');
hylabel = ylabel('Cluster');
htitle = title('Firing rate');
hcm = colormap('jet');
hcb = colorbar;
%ylabel(hcb,'Hz');
hold(haxes,'off');

% Parameters
fontname = 'Arial';
fontsize = 8;

set(hfig,...
    'NumberTitle','on',...
    'Name','Firing rate'...
    );
%     'PaperUnits', 'centimeters',...
%     'PaperPosition', [7 7 12 9],...

hcb.Label.String = 'Hz';

ClusterLabel = int2str(CluID');
set(haxes,...
    'YTick',[1:length(CluID)],...
    'YTickLabel', ClusterLabel,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );
%     'YLim',[0.5,counter - 0.5],...
%     'Ydir','reverse',...

set(hxlabel,...
    'HorizontalAlignment', 'center'...
    );

set(hylabel,...
    'HorizontalAlignment', 'center'...
    );

hstruct.hfig = hfig;
hstruct.him = him;
hstruct.hcm = hcm;
hstruct.hcb = hcb;
hstruct.haxes = haxes;
hstruct.hxlabel = hxlabel;
hstruct.hylabel = hylabel;
hstruct.htitle = htitle;
% hstruct.hlegend = hlegend;
