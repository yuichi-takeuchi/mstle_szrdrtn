function yfNiDaqAoBContDoConstTrig(AoCh, AoWaveform, rate, timeout, TriggerTimeout, DoCh, binaryVector, Latency)
%
%   yfNiDaqAoBContDoConstTrig(AoCh, AoWaveform, rate, timeout, TriggerTimeout, DoCh, binaryVector, Latency)
%   AoCh: Vector
%   AoWaveform: Vector or Matrix for one second
%   rate: sampling rate in Hz
%   timeout : in second
%   TriggerTimeout: in second
%   DoCh: string like '0:3'
%   binaryVector: [Do0, Do1, Do2, Do3]
%   Latency: in second, time with ditigal outputs before and afer stimulation
%
% Copyright (c) 2017 Yuichi Takeuchi
%

d = daq.getDevices;
s1 = daq.createSession('ni');                        % Create a session for National Instruments devices.
s1.Rate = rate;
% s1.IsContinuous = true;
addAnalogOutputChannel(s1, d.ID, AoCh, 'Voltage');

addTriggerConnection(s1, 'External', 'Dev1/PFI0', 'StartTrigger');   % Create an externaal trigger connection and set the trigger to run on time.
s1.Connections(1).TriggerCondition = 'RisingEdge';
s1.TriggersPerRun = 1000;
s1.ExternalTriggerTimeout = TriggerTimeout;

% Queue the Data
OutputSignal = AoWaveform'; %OutputSignal = sin(linspace(0, pi*2, s.Rate)');
OutputSignal = repmat(OutputSignal, 1, size(AoCh,2));
queueOutputData(s1,OutputSignal);

counter = 1;
% lh = addlistener(s,'DataRequired', @(src,event) src.queueOutputData(OutputSignal));
lh = addlistener(s1,'DataRequired', @moreOutput);
    function moreOutput(src, event)
        eTime = toc(tStart);
        if(eTime < (timeout - 1))
            queueOutputData(src, OutputSignal);
            display(['queueOutputData' num2str(counter)])
            counter = counter + 1;
        else
            s1.stop();delete(lh);
        end
    end

% Sound
% StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
% EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);

% s2 = daq.createSession('ni');                        % Create a session for National Instruments devices.
% addDigitalChannel(s2, d.ID, ['port0/line' DoCh],'OutputOnly');

% Reset singals
digitalReset = zeros(1,length(binaryVector));

% sound(StartSound, 5000);
% outputSingleScan(s2, binaryVector)
pause(Latency)
disp('wating trig...')
s1.startBackground();
tStart = tic;
s1.wait()
% s1.wait(timeout)
outputSingleScan(s1, 0);
% pause(Latency)
% outputSingleScan(s2, digitalReset);
% sound(EndSound, 5000);
disp('done')
end

