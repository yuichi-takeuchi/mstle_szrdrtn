function [ hstruct ] = unf_WaveformPlotSelected( Channels, SrcWaveAvg, SrcWaveStd, axisVisible, fignum)
% [ hstruct ] = unf_WaveformPlotSelected( Channels, SrcWaveAvg, SrcWaveStd, axisVisible, fignum)
%   unf_WaveformPlotSelected draws averages waveforms of selected recording
%   channels
%
%   Channels: Vector for selected recording channels
%   SrcWaveAvg: Averaged waveforms
%   SrcWaveStd: Standard deviations of waveforms
%   axisVisible: True or Fals
%   fignum: figure number
%
% Copyright (C) 2017 Yuichi Takeuchi
% 

ColorCell = {'y';'r';'k';'m';'b';'k';'c';'g'};
ScaleBarXX = [55 65]; % 0.5 ms
ScaleBarXY = [-2000 -2000];
ScaleBarYX = [65 65];
ScaleBarYY = [-2000 -1738]; % 200 uV
hfig = figure(fignum); arrayfun(@cla,gca)
hold on;
for i = 1:8;
    WaveAvg = SrcWaveAvg(:,Channels(i));
    WaveStdP = WaveAvg + SrcWaveStd(:, Channels(i));
    WaveStdM = WaveAvg - SrcWaveStd(:, Channels(i));
    hplot(i).Avg = plot(WaveAvg - 250*(i-1), ['-' ColorCell{i}], 'LineWidth', 1);
    hplot(i).StdP = plot(WaveStdP - 250*(i-1), ['--' ColorCell{i}]);
    hplot(i).StdM = plot(WaveStdM - 250*(i-1), ['--' ColorCell{i}]);
end
hxscale = plot(ScaleBarXX, ScaleBarXY,'k', 'LineWidth', 1);
hyscale = plot(ScaleBarYX, ScaleBarYY, 'k', 'LineWidth', 1);
hold off;
xlim([1 size(WaveAvg,1)] + 5)
ylim([-2000 250])

if ~axisVisible
    set(gca, 'Visible', 'off')
end

hstruct.hfig = hfig;
hstruct.hplot = hplot;
hstruct.hxscale = hxscale;
hstruct.hyscale = hyscale;

end

