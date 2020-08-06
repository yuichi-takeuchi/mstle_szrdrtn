function yfNiDaqAoSS(AoCh, Value)
%
%   yfNiDaqAoSS(AoCh, Value)
%   AoCh: Vector
%   Value: Vector
%
% Copyright (c) 2016 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');

aoch = addAnalogOutputChannel(s, d.ID, AoCh, 'Voltage');

StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);

sound(StartSound, 5000);
outputSingleScan(s, Value);
sound(EndSound, 5000);
