function [Data, Time] = yfNiDaqAiF(AiCh, rate, duration)
%
%   [Data, Time] = yfNiDaqAiF(AiCh, rate, duration)
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
% ch(1).TerminalConfig = 'SingleEnded';   % Configure the terminal and range of the chanels in the session.
% ch(1).Range = [-10.0 10.0];

% Sound
StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);

sound(StartSound, 5000);

[Data, Time] = s.startForeground();
plot(Time, Data)

sound(EndSound, 5000);
end