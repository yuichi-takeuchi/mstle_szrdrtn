function [hstruct] = unf_FeaturePlot(PC, EV, CluID, fignum)
%
% Feature Plot
% [hstruct] = unf_FeaturePlot(PC, EV, fignum)
% 
%   PC: matrix (number of components, the first theree PC)
%   EV: vector (percent contribution of PC1, PC2, PC3)
%   CluID: vector as *.Clu.* files
%
% Copyright (C) 2017 Yuichi Takeuchi
%

hfig = figure(fignum);
LegStr = cell(length(CluID),1);
nn = 1;
for clu = CluID
    index = CluVec == clu;
    x = PC(index,1);
    y = PC(index,2);
    z = PC(index,3);
    hp = plot3(x,y,z,'o');
    haxes = gca;
    hold(haxes, 'on')
    r = rand(1,3);
    set(hp,'Color',[r(1),r(2),r(3)]);
    LegStr{nn,1}=['Clu' num2str(clu)];
    nn = nn + 1;
end
hold(haxes, 'off')

% putting eigen value on labels
hxlabel = xlabel(['PCA 1 (',num2str(EV(1)),'%)']);
hylabel = ylabel(['PCA 2 (',num2str(EV(2)),'%)']);
hzlabel = zlabel(['PCA 3 (',num2str(EV(3)),'%)']);
% legend
hlegend = legend(LegStr);

set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [7 7 12 9],...
    'NumberTitle','on',...
    'Name',['Feature Plot Cluster ', num2str(CluID)]...
);

hstruct.hfig = hfig;
hstruct.haxes = hp;
hstruct.hxlabel = hxlabel;
hstruct.hylabel = hylabel;
hstruct.hzlabel = hzlabel;
hstruct.hlegend = hlegend;
