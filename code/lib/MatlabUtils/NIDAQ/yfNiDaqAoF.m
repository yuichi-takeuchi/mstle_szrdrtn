function yfNiDaqAoF(AoCh, AoWaveform, rate)
%
%   yfNiDaqAoF(AoCh, AoWaveform, rate)
%   AoCh: Vector
%   AoWaveform: Vector or Matrix
%   rate: sampling rate in Hz
%
% Copyright (c) 2016 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');                        % Create a session for National Instruments devices.
s.Rate = rate;
ch = addAnalogOutputChannel(s, d.ID, AoCh, 'Voltage');

% generate a single scan
% outputSingleValue = 2;
% outputSingleScan(s,[outputSingleValue outputSingleValue]);

% Queue the Data
OutputSignal = AoWaveform'; %OutputSignal = sin(linspace(0, pi*2*duration, s.Rate*duration)');

% Time = linspace(0, duration, s.Rate*duration);
% plot(Time, OutputSignal);
% xlabel('Time');
% ylabel('Voltage');

OutputSignal = repmat(OutputSignal, 1, size(AoCh,2));
queueOutputData(s, OutputSignal);

% Sound
% StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
% EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);
% 
% sound(StartSound, 5000);

s.startForeground;
outputSingleScan(s, 0);
% 
% sound(EndSound, 5000);
end