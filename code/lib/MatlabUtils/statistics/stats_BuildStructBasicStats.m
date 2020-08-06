function [ destStruct ] = stats_BuildStructBasicStats( srcMat )
%
% [ destStruct ] = stats_Summary1( srcMat )
%
% caluculation arong column
%   
% Copyright (C) Yuichi Takeuchi 2017
%

Prctile = prctile(srcMat, [0 10 25 50 75 90 100]);

destStruct = struct(...,
    'Mean', mean(srcMat),...
    'Std', std(srcMat),...
    'Sem', sem(srcMat),...
    'Prctile', Prctile...
    );

end

