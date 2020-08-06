function yfNiDaqAoFTrig(AoCh, AoWaveform, rate, TriggerTimeout)
%
%   yfNiDaqAoFTrig(AoCh, AoWaveform, rate, TriggerTimeout)
%   AoCh: Vector
%   AoWaveform: Vector or Matrix
%   rate: sampling rate in Hz
%   TriggerTimeout: in s
%
% Copyright (c) 2016, 2017 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');                        % Create a session for National Instruments devices.
s.Rate = rate;
ch = addAnalogOutputChannel(s, d.ID, AoCh, 'Voltage');

% generate a single scan
% outputSingleValue = 2;
% outputSingleScan(s,[outputSingleValue outputSingleValue]);

addTriggerConnection(s, 'External', 'Dev1/PFI0', 'StartTrigger');   % Create an externaal trigger connection and set the trigger to run on time.
s.Connections(1).TriggerCondition = 'RisingEdge';
s.TriggersPerRun = 100;
s.ExternalTriggerTimeout = TriggerTimeout;

% Queue the Data
OutputSignal = AoWaveform'; %OutputSignal = sin(linspace(0, pi*2*duration, s.Rate*duration)');

% Time = linspace(0, duration, s.Rate*duration);
% plot(Time, OutputSignal);
% xlabel('Time');
% ylabel('Voltage');

OutputSignal = repmat(OutputSignal, 1, size(AoCh,2));
ii = 0;
% while(1)
queueOutputData(s, OutputSignal);

% Sound
% StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
% EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);
% 
% sound(StartSound, 5000);
disp('waiting trigger...')
s.startForeground;
% outputSingleScan(s, 0);
    ii = ii + 1;
    disp(ii)
disp('done')
% end
% sound(EndSound, 5000);
end