function yfNiDaqLoadLog(AiCh)
%
%   yfNiDaqLoadLog(AiCh)
%   AiCh: Vector
%
% Copyright (c) 2015 Yuichi Takeuchi
%

fid2 = fopen('log.bin','r');
[data,count] = fread(fid2,[length(AiCh)+1,inf],'double');

Time = data(1,:);
Data = data(2:(length(AiCh)+1),:);
plot(Time, Data);

% Write a Function to Log the Data.
fclose(fid2);
