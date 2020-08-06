function nidaqf_ControlAndSineWaveStimuli( sinewaveHz, ScaledVoltage, cycles, mintime, Latency, afterpause, trials )
%
%   nidaqf_ControlAndSineWaveStimuli( sinewaveHz, pulsewidth, ScaledVoltage, cycles, timeout, Latency, afterpause, trials )
%   sinewaveHzwaveHz: vector of stimulation Hz
%   ScaledVoltage: maximal amplitude
%   cycles: minimum pulse number
%   mintime: minimum time of control or stimulation epoch
%   Latency: time between digital output and analog output (in second)
%   afterpause: pause time after stimulation (in second)
%   trials: number of trials
%
% Copyright (c) 2017 Yuichi Takeuchi
%

AoCh = [0];
DoCh = '0:3';
rate = 20000; % Hz

for k = 1:length(sinewaveHz)
    display(['sinewave ' num2str(sinewaveHz(k)) ' Hz'])
    timeout = cycles/sinewaveHz(k);
    if(timeout < mintime)
        timeout = mintime;
    end
    for j = 1:trials
        display(['trial ' num2str(j)])
        display('control epoch')
        dec = 2*k - 1;
        yfNiDaqDo(DoCh, decimalToBinaryVector(dec, 4, 'LSBFirst'))
        tStart = tic;
        eTime = 0;
        counter = 0;
        while(eTime < timeout)
            pause(1)
            counter = counter + 1;
            display([num2str(counter) ' s'])
            eTime = toc(tStart);
        end
        dec = 2*k;
        [stimwave, t] = stimf_CreateSineWave(sinewaveHz(k),1.5*pi,1,rate); % PulseFreq, StartingPhase, Duration, SamplingFreq
        stimwave = stimwave/2 + 0.5;
        ScaledStimwave = ScaledVoltage*stimwave;
%         ScaledStimwave(ScaledStimwave > 1.5) = 1.5;
        display('stimulation epoch')
        yfNiDaqAoBContDoConst(AoCh, ScaledStimwave, rate, timeout, DoCh, decimalToBinaryVector(dec, 4, 'LSBFirst'), Latency)
        pause(afterpause)
    end
end

display('nidaq_ControlAndSineWaveStimuli end')