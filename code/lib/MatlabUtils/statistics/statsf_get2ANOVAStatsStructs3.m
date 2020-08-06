function [ sBasicStats, sStatsTest ] = statsf_get2ANOVAStatsStructs3( dataVector, linearVector, OnOffIndex, varName)
%
% This function returns structures containing results of discriptive
% statistics and statistical tests.
% 
% INPUTS:
%    dataVector: data vecotr to be analyzed
%    linearVector: linear factor
%    OnOffIndex (logical): logical vector, 0 for off and 1 for true
%    varName (string): description of dataVector
% OUTPUT:
%    sBasicStats: Cell vector, each element of which contains one
%    sStatsTest: structure for statistical tests
%
% Copyright(c) 2020 Yuichi Takeuchi
%

Off = dataVector(~OnOffIndex);
OffLin = linearVector(~OnOffIndex);
On  = dataVector(OnOffIndex);
OnLin = linearVector(OnOffIndex);

% calculating basic statistics
sBasicStats.Variable = varName;

[ MeanOff, StdOff, SemOff, PrctileOff ] = stats_Summary2( Off, OffLin );
[ MeanOn, StdOn, SemOn, PrctileOn ] = stats_Summary2( On, OnLin );

sBasicStats.Mean = [MeanOff; MeanOn];
sBasicStats.Std = [StdOff; StdOn];
sBasicStats.Sem = [SemOff; SemOn];
sBasicStats.Prctile = [PrctileOff; PrctileOn];

% statistical test (two-way ANOVA with multicompare)
sStatsTest.Variable = varName;
y = dataVector;
gOnOff = OnOffIndex;
gLinear = linearVector;
[p, tbl, stats, terms] = anovan(y, {gOnOff, gLinear}, 'model', 'interaction', 'varnames', {'gOnOff', 'gLinear'}, 'display', 'off');
c = multcompare(stats, 'Dimension',[1 2], 'display', 'off');
sStatsTest.PValues = p;
sStatsTest.Table = tbl;
sStatsTest.Structure = stats;
sStatsTest.Terms = terms;
sStatsTest.MultiComp = c;


