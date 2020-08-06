function nidaqf_InterleavedSine1( sinewaveHz, scaledVoltage, timeout, Latency, afterpause, trials )
%
%   nidaqf_InterleavedSine1( sinewaveHz, scaledVoltage, timeout, Latency, afterpause, trials )
%   sinewaveHzwaveHz: vector of stimulation Hz
%   ScaledVoltage: maximal amplitude
%   timeout: duration of stimuli (in sec)
%   Latency: time between digital output and analog output (in second)
%   afterpause: pause time after stimulation (in second)
%   trials: number of trials
%
%   tested DAQ device: NI USB-6212
%
% Copyright (c) 2018 Yuichi Takeuchi
%

AoCh = [0];
DoCh = '0:3';
rate = 20000; % Hz

disp(['sinewave ' num2str(sinewaveHz) ' Hz'])

for j = 1:trials
    disp(['trial ' num2str(j)])
    disp('control epoch')
    dec = 2;
    yfNiDaqDo(DoCh, decimalToBinaryVector(dec, 4, 'LSBFirst'))
    tStart = tic;
    eTime = 0;
    counter = 0;
    while(eTime < timeout)
        pause(1)
        counter = counter + 1;
        disp([num2str(counter) ' s'])
        eTime = toc(tStart);
    end
    dec = 3;
    [stimwave, t] = stimf_CreateSineWave(sinewaveHz,1.5*pi,1,rate); % PulseFreq, StartingPhase, Duration, SamplingFreq
    stimwave = stimwave/2 + 0.5;
    ScaledStimwave = scaledVoltage*stimwave;
%     ScaledStimwave(ScaledStimwave > 1.5) = 1.5;
    disp('stimulation epoch')
    yfNiDaqAoBContDoConst(AoCh, ScaledStimwave, rate, timeout, DoCh, decimalToBinaryVector(dec, 4, 'LSBFirst'), Latency)
    pause(afterpause)
end

disp('nidaq_InterleavedSine1 end')