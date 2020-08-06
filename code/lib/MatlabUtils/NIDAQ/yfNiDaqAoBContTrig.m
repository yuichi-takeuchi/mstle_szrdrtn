function yfNiDaqAoBContTrig(AoCh, AoWaveform, rate, timeout, TriggerTimeout)
%
%   yfNiDaqAoBContTrig(AoCh, AoWaveform, rate, timeout, TriggerTimeout)
%   AoCh: Vector
%   AoWaveform: Vector or Matrix for one second
%   rate: sampling rate in Hz
%   timeout: in second
%   TriggerTimeout: in second
%
% Copyright (c) 2016, 2017 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');                        % Create a session for National Instruments devices.
s.Rate = rate;
% s.IsContinuous = true;
addAnalogOutputChannel(s, d.ID, AoCh, 'Voltage');

addTriggerConnection(s, 'External', 'Dev1/PFI0', 'StartTrigger');   % Create an externaal trigger connection and set the trigger to run on time.
s.Connections(1).TriggerCondition = 'RisingEdge';
s.TriggersPerRun = 100;
s.ExternalTriggerTimeout = TriggerTimeout;

% Queue the Data
OutputSignal = AoWaveform'; %OutputSignal = sin(linspace(0, pi*2, s.Rate)');

% plot(OutputSignal)
% Time = linspace(0, 1, s.Rate);
% plot(Time, OutputSignal);
% xlabel('Time');
% ylabel('Voltage');

OutputSignal = repmat(OutputSignal, 1, size(AoCh,2));
queueOutputData(s,OutputSignal);

counter = 1;
% lh = addlistener(s,'DataRequired', @(src,event) src.queueOutputData(OutputSignal));
lh = addlistener(s,'DataRequired', @moreOutput);
    function moreOutput(src, event)
        eTime = toc(tStart);
        if(eTime < (timeout - 1))
            queueOutputData(src, OutputSignal);
            display(['queueOutputData' num2str(counter)])
            counter = counter + 1;
        else
            s.stop();
            delete(lh);
        end
    end

% Sound
% StartSound = sin(linspace(0, 2*pi*440, 5000)); StartSound = StartSound(1:1500);
% EndSound = sin(linspace(0, 2*pi*880, 5000)); EndSound = EndSound(1:2500);
% 
% sound(StartSound, 5000);
s.startBackground();
disp('wating trigger...')
tStart = tic;
s.wait()
% s.wait(timeout)
outputSingleScan(s, 0);
disp('done')
% sound(EndSound, 5000);

end

