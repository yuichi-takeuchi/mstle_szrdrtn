function [timeInMS]= tsf_formatTime2ms(TM)
% transform minute second ms to ms
% 
% input: 
%      format: min s ms matrix (e.g [20 13 200; 45 12 302; ...] 
%      means [(20 minute 13 second 200 ms) (45 minute 12 second 302 ms)] )
% output: millisecond format matrix TS
%
% Copyright (C) 2020 Yuichi Takeuchi

T1 = TM(:,1);
T2 = TM(:,2);
T3 = TM(:,3);
timeInMS = T1.*(60*1000) + T2.*1000 + T3;

end
