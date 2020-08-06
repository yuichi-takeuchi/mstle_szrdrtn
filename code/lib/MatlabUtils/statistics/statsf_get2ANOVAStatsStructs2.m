function [ sBasicStats, sStatsTest ] = statsf_get2ANOVAStatsStructs2( srcTable, dataVarNames, linearVarName, OnOffIndex)
%
% This function returns structures containing results of discriptive
% statistics and statistical tests.
%
% INPUTS:
%    srcTable (table): source table
%    dataVarNames (cell): variable name list for quantitative analysis
%    linearVarName (char): variabl name for linear factor
%    OnOffIndex (logical): logical vector, 0 for off and 1 for true
% OUTPUT:
%    sBasicStats: Cell vector, each element of which contains one
%    sStatsTest: structure for statistical tests
%
% Copyright(c) 2018, 2019, 2020 Yuichi Takeuchi
%

for i = 1:length(dataVarNames)
    Off = srcTable.(dataVarNames{i})(OnOffIndex);
    OffLin = srcTable.(linearVarName)(OnOffIndex);
    On  = srcTable.(dataVarNames{i})(OnOffIndex);
    OnLin = srcTable.(linearVarName)(OnOffIndex);
       
    % calculating basic statistics
    sBasicStats(i).Variable = dataVarNames{i};
    [ MeanOff, StdOff, SemOff, PrctileOff ] = stats_Summary2( Off, OffLin );
    [ MeanOn, StdOn, SemOn, PrctileOn ] = stats_Summary2( On, OnLin );
    
    sBasicStats(i).Mean = [MeanOff; MeanOn];
    sBasicStats(i).Std = [StdOff; StdOn];
    sBasicStats(i).Sem = [SemOff; SemOn];
    sBasicStats(i).Prctile = [PrctileOff; PrctileOn];

    % statistical test (two-way ANOVA with multicompare)
    sStatsTest(i).Variable = dataVarNames{i};
    y = srcTable.(dataVarNames{i});
    gOnOff = srcTable.(OnOffVarName);
    gLinear = srcTable.(linearVarName);
    [p, tbl, stats, terms] = anovan(y, {gOnOff, gLinear}, 'model', 'interaction', 'varnames', {'gOnOff', 'gLinear'}, 'display', 'off');
    c = multcompare(stats, 'Dimension',[1 2], 'display', 'off');
    sStatsTest(i).PValues = p;
    sStatsTest(i).Table = tbl;
    sStatsTest(i).Structure = stats;
    sStatsTest(i).Terms = terms;
    sStatsTest(i).MultiComp = c;
end

