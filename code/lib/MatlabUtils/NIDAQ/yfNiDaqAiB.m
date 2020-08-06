function [Data, Time] = yfNiDaqAiB(AiCh, rate, duration)
%
%   [Data, Time] = yfNiDaqAiB(AiCh, rate, duration)
%   AiCh: Vector
%   rate: sampling rate in Hz
%   duration: in s
%   Data: Matrix or Matrix
%   Time: Vector
%
% Copyright (c) 2015 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');                        % Create a session for National Instruments devices.
s.Rate = rate;
s.DurationInSeconds = duration;

ch = addAnalogInputChannel(s, d.ID, AiCh, 'Voltage');
for i = (1:length(AiCh))
    ch(i).Range = [-10.0 10.0];    % Set the same ragen and terminals for all the channels.
    ch(i).TerminalConfig = 'SingleEnded';   % Configure the terminal and range of the chanels in the session.
end

fid1 = fopen('log.bin','w');
%lh = addlistener(s,'DataAvailable', @(src,event) plot(event.TimeStamps, event.Data));
%lh = addlistener(s,'DataAvailable', @plotData);
lh = addlistener(s,'DataAvailable',@(src, event)yfplotlogData(src, event, fid1));
% s.NotifyWhenDataAvailableExceeds = 2000;

s.startBackground();
s.wait(duration + 1);
delete(lh);

fclose(fid1);
fid2 = fopen('log.bin','r');
[data,count] = fread(fid2,[length(AiCh)+1,inf],'double');

Time = data(1,:);
Data = data(2:(length(AiCh)+1),:);
plot(Time, Data);

% Write a Function to Log the Data.
fclose(fid2);
end

% function plotData(src,event)
%      plot(event.TimeStamps, event.Data)
% end