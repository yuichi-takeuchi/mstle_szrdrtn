function [Data, Time] = yfNiDaqAiAoF(AiCh, AoCh, AoWaveform, rate)
%
%   [Data, Time] = yfNiDaqAiAoF(AiCh, AoCh, AoWaveform, rate)
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

aich = addAnalogInputChannel(s, d.ID, AiCh(1,:), 'Voltage');
for i = (1:size(AiCh,2))
    aich(i).Range = [-10.0 10.0];    % Set the same ragen and terminals for all the channels.
    if(size(AiCh, 1) >1)
        switch AiCh(2, i)
            case 1
                aich(i).TerminalConfig = 'SingleEnded';
            case 2
                aich(i).TerminalConfig = 'NonReferencedSingleEnded';
            case 3
                aich(i).TerminalConfig = 'Differential';
            case 4
                aich(i).TerminalConfig = 'PseudoDifferential';
            otherwise
            aich(i).TerminalConfig = 'SingleEnded';
        end    
    else
        aich(i).TerminalConfig = 'SingleEnded';
    end
end

aoch = addAnalogOutputChannel(s, d.ID, AoCh, 'Voltage');

OutputSignal = AoWaveform';
queueOutputData(s, OutputSignal);

StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);

sound(StartSound, 5000);

[Data, Time] = s.startForeground();
outputSingleScan(s, 0);

sound(EndSound, 5000);

% on/off
% plotdata(Data, Time, AoWaveform)
end

function plotdata(Data, Time, AoWaveform)
subplot(2, 1, 1)
plot(Time, AoWaveform)
ylabel('Voltage');
xlabel('Time');
title('Output wave')
grid on
subplot(2, 1, 2)
plot(Time, Data)
ylabel('Voltage');
xlabel('Time');
title('Acquired Signal')
grid on;
end