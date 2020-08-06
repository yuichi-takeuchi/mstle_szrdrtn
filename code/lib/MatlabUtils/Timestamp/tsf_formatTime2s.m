function [timeInS]= tsf_formatTime2s(TM)
% transform minute second ms to s
% 
% input: 
%      format: min s ms matrix (e.g [20 13; 45 12; ...] 
%      means [(20 minute 13 second) (45 minute 12 second)] )
% output: second format matrix timeInS
%
% Copyright (C) 2020 Yuichi Takeuchi

T1 = TM(:,1);
T2 = TM(:,2);
timeInS = T1.*60 + T2;

end
