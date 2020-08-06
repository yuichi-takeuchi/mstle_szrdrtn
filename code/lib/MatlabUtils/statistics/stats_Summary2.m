function [ Mean, Std, Sem, Prctile ] = stats_Summary2( srcValue1, srcValue2 )
%
% [ Mean, Std, Sem, Prctile ] = stats_Summary2( srcValue1, srcValue2 )
%
% caluculation arong column
%   
% Copyright (C) Yuichi Takeuchi 2017
%

Mean = zeros(1, length(unique(srcValue2)));
Std = zeros(1, length(unique(srcValue2)));
Sem = zeros(1, length(unique(srcValue2)));
Prctile = zeros(7, length(unique(srcValue2)));

RefValue = sort(unique(srcValue2));

for i = 1:length(unique(srcValue2))
    Value = srcValue1(srcValue2 == RefValue(i));
    
    Mean(i) = nanmean(Value);
    Std(i) = nanstd(Value);
    Sem(i) = nansem(Value);
    Prctile(:,i) = prctile(Value, [0 10 25 50 75 90 100]);
end

end

