function [Data, Time] = yfNiDaqAiAoB(AiCh, AoCh, AoWaveform, rate)
%
%   [Data, Time] = yfNiDaqAiAoB(AiCh, AoCh, AoWaveform, rate)
%   AiCh: Vector
%   AoCh: Vector
%   AoWaveform: Vector or Matrix
%   rate: sampling rate in Hz
%   Data: Matrix or Matrix
%   Time: Vector
%
% Copyright (c) 2015 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');
s.Rate = rate;

aich = addAnalogInputChannel(s, d.ID, AiCh, 'Voltage');
for i = (1:length(AiCh))
    aich(i).Range = [-10.0 10.0];    % Set the same ragen and terminals for all the channels.
    aich(i).TerminalConfig = 'SingleEnded';   % Configure the terminal and range of the chanels in the session.
end

aoch = addAnalogOutputChannel(s, d.ID, AoCh, 'Voltage');

OutputSignal = AoWaveform';
queueOutputData(s, OutputSignal);

fid1 = fopen('log.bin','w');
lh = addlistener(s,'DataAvailable',@(src, event)yfplotlogData(src, event, fid1));

% Sound
StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);

sound(StartSound, 5000);
s.startBackground();
s.wait(size(AoWaveform, 2)/rate + 1);
delete(lh);

sound(EndSound, 5000);
fclose(fid1);
fid2 = fopen('log.bin','r');
[data,count] = fread(fid2,[length(AiCh)+1,inf],'double');

Time = data(1,:);
Data = data(2:(length(AiCh)+1),:);

% subplot(2, 1, 1)
% plot(Time, AoWaveform)
% ylabel('Voltage');
% xlabel('Time');
% title('Output wave')
% grid on
% subplot(2, 1, 2)
% plot(Time, Data)
% ylabel('Voltage');
% xlabel('Time');
% title('Acquired Signal')
% grid on;

% Write a Function to Log the Data.
fclose(fid2);

end