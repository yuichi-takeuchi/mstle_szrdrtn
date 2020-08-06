function nidaqf_InterleavedSquare1( pulseFreq, pulseWidth, scaledVoltage, timeout, latency, afterPause, trialNo )
%
%   nidaqf_InterleavedSquare1( sineWaveHz, pulseWidth, scaledVoltage, cycles, timeout, Latency, afterPause, trials )
%   pulseFreq: freqency of pulse stimulation Hz
%   
%   scaledVoltage: maximal amplitude in volt
%   timeout: duration of stimuli (in sec)
%   Latency: time between digital output and analog output (in second)
%   afterpause: pause time after stimulation (in second)
%   trialNo: number of trialNo
%
%   tested DAQ device: NI USB-6212
%
% Copyright (c) 2018 Yuichi Takeuchi
%

AoCh = [0];
DoCh = '0:3';
rate = 20000; % Hz

disp(['squarePulseFreq ' num2str(pulseFreq) ' Hz'])

for j = 1:trialNo
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
    [Stimwave, t] = stimf_CreateSquarePulses(pulseFreq, pulseWidth, 1, rate); % PulseFreq, PulseWidth, Duration, SamplingFreq
    ScaledStimwave = scaledVoltage*Stimwave;
    disp('stimulation epoch')
    yfNiDaqAoBContDoConst(AoCh, ScaledStimwave, rate, timeout, DoCh, decimalToBinaryVector(dec, 4, 'LSBFirst'), latency)
    pause(afterPause)
end

disp('nidaq_InterleavedSquare1 end')