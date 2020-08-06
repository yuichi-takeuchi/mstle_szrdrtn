function [ hp ] = plotf_ScaledTraces1(hax, t, data, ChGroup)
%
% Copyright (C) Yuichi Takeuchi 2018

% axis off
hold(hax,'on')
for i = 1:numel(ChGroup)
    srcWave = data(ChGroup(i),:);
    srcWave = srcWave + 2*i - numel(ChGroup);
    hp = plot(t, srcWave, 'k', 'LineWidth', 0.1);
end
hold(hax,'off')

