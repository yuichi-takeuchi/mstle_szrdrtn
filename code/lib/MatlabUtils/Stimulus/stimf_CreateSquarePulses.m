function [SquareWave,Time] = stimf_CreateSquarePulses(PulseFreq, PulseWidth, Duration, Fs)
% 
%   [SquareWave,Time] = stimf_CreateSquarePulses(PulseFreq, PulseWidth, Duration, Fs)
%   PulseFreq: in Hz
%   PluseWidth: in second
%   Duration: in second
%   Fs: sampling rate
%   SquareWave: output square pulse
%   Time: in second
% 
% Copyright (c) 2016 Yuichi Takeuchi
%

Time = 0:1/Fs:Duration;
pulseperiods = [0:floor(Duration*PulseFreq)]*Duration/PulseFreq;
SquareWave = pulstran(Time,pulseperiods,@rectpuls,PulseWidth);
SquareWave(end) = [];
Time(end) = [];

%
% plot(Time,SquareWave)

