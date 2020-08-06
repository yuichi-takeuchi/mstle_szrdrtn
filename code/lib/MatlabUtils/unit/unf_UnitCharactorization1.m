function [ hstruct ] = unf_UnitCharactorization1( UnitInfo, numRec, fignum )
%   
% Copyright (C) 2017 Yuichi Takeuchi
%

hfig = figure(fignum); arrayfun(@cla,gca)

% PSTH plot
h(1).haxes = subplot(4,3,1);
% ha(1) = subplot(4,3,1);
t = UnitInfo(numRec).PSTH.Time;
CCGR = UnitInfo(numRec).PSTH.CCGR;
CCGMean = UnitInfo(numRec).PSTH.CCGMean;
Global = UnitInfo(numRec).PSTH.Global;
Local = UnitInfo(numRec).PSTH.Local;
Title = ['Square pulse stimuli'];
[ hstruct ] = unf_CCG_PlotMeanGlbLcl1( t, CCGR, CCGMean, Global, Local, Title );
h(1).hylabel = ylabel('#Spikes');
h(1).hxlabel = xlabel('Time (ms)');
h(1).htitle = hstruct.htitle;
yl = get(gca, 'YLim');
p = patch([0 10 10 0],[yl(1) yl(1) yl(2) yl(2)],'b');
set(p,'FaceAlpha',0.25,'edgecolor','none');
clear t CCGR CCGMean Global Local Title hstruct yl p

% ACG
h(2).haxes = subplot(4,3,2);
% ha(2) = subplot(4,3,2);
h(2).hbar = bar(UnitInfo(numRec).ACG.Time, UnitInfo(numRec).ACG.Baseline, 'facecolor','k','edgecolor','k');
xlim([min(UnitInfo(numRec).ACG.Time) max(UnitInfo(numRec).ACG.Time)]);
box off;
% h(2).hylabel = ylabel('#spikes');
h(2).hxlabel = xlabel('Time (ms)');
h(2).htitle = title(['Auto-correlogram']);

% Waveform and FR
h(3).haxes = subplot(4,3,3);
% ha(3) = subplot(4,3,3);
Channels = UnitInfo(numRec).Channel.Range;
SrcWaveAvg = UnitInfo(numRec).Waveform.Average;
SrcWaveStd = UnitInfo(numRec).Waveform.Std;
axisVisible = true;
[ hstruct ] = unf_WaveformPlotSelected( Channels, SrcWaveAvg, SrcWaveStd, axisVisible, fignum );
FRMean = UnitInfo(numRec).BaseFRMean;
FRStd = UnitInfo(numRec).BaseFRStd;
str1 = ['FR: ' num2str(FRMean) ' ± ' num2str(FRStd) ' Hz'];
str2 = ['Mean MI: ' num2str(UnitInfo(numRec).StimMI(1))];
if UnitInfo(numRec).StimSignif(1)
    str2 = [str2 ' *p < 0.05'];
else
    str2 = [str2 ' n.s. p > 0.05'];
end
h(3).htitle = title({str1, str2});
% annotation(gca, 'textbox', [0.3 0.75 0.4 0.2], 'String', str, 'LineStyle', 'none');
clear Channels ColorCell fignum i SrcWaveAvg SrcWaveStd hstruct str1 str2 FRMean FRStd axisVisible

% 1, 8, 20 Hz sinusoidal stimulus
indInt = 1;
indHz = [1 3 5];
CHz = {'1', '8', '20'};
for j = 1:3
    h(j+3).haxes = subplot(4,3,j+3);
%     ha(j+3) = subplot(4,3,j+3);
    Src = UnitInfo(numRec).StimCircHist.Count{indInt,indHz(j)}(1,:);
    Title = [CHz{j} ' Hz'];
    [ hstruct ] = unf_PlotPhaseHist1( Src, 20, 720, '-b', Title);
    h(j+3).htitle = hstruct.htitle;
    if j == 1
        h(j+3).ylabel = ylabel('#Spikes');
    end
%         h(j+3).xlabel = xlabel('Phase');
end
%     axes; title(['Sinusoial illumination: ' num2str(unqInt(indInt)) ' mW, ' num2str(unqHz(indHz)) ' Hz']); axis off;
clear fignum Src indInt indHz j hstruct
clear Title CHz

% delta theta beta intrinsic phase modulation
FNames = fieldnames(UnitInfo(numRec).NetworkHist);
for i = 1:6
    h(i+6).haxes = subplot(4,3,i+6);
%     ha(i+6) = subplot(4,3,i+6);
    Src = UnitInfo(numRec).NetworkHist.(FNames{i})(1,:);
    Title = FNames{i};
    [ hstruct ] = unf_PlotPhaseHist1( Src, 20, 720, '-r', Title);
    h(i+6).htitle = hstruct.htitle;
    if i == 1 || i == 4
        h(i+6).ylabel = ylabel('#Spikes');
    end
    if i > 3
        h(i+6).xlabel = xlabel('Phase');
    end
end
pos = get([h.haxes], 'Position');
dim = cellfun(@(x) x+[0 0 0 0], pos, 'uni',0);
for i = 1:6
    str = ['MI: ' num2str(UnitInfo(numRec).NetworkMI(i))];
    if UnitInfo(numRec).NetworkSignif(i)
        str = [str ', *p < 0.05'];
    else
        str = [str ', n.s. p > 0.05'];
    end
    h(i+6).ht = annotation(hfig, 'textbox', dim{i+6}, 'String', str, 'LineStyle', 'none');
end
clear fignum i Src indInt indHz hstruct FNames Title CHz dim str pos

%figure title
axes;
htitle = title([num2str(UnitInfo(numRec).datfileID) ', ' UnitInfo(numRec).StimLabel ', Clu:' num2str(UnitInfo(numRec).CluID)]);
axis off;

% Parameter settings
% Parameters
fontname = 'Arial';
fontsize = 3;

set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.1 0.1 5.8 5.8],...
    'PaperSize', [6 6],...
    'NumberTitle','on'...
    );
%         'Name','Figure 3_1'...

set(htitle,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

for i = 1:12
    set(h(i).haxes,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );
end

set(h(3).haxes,...
    'XTickLabel',[],...
    'YTickLabel',[],...
    'TickLength', [0;0]...
    );

for i = 7:12
    set(h(i).ht,...
        'FontName', fontname,...
        'FontSize', (fontsize - 1)...
        );
end

% file output
print([UnitInfo(numRec).StimLabel '_' num2str(UnitInfo(numRec).datfileID) '_Clu' num2str(UnitInfo(numRec).CluID) '.pdf'], '-dpdf');

hstruct.hfig = hfig;
end

