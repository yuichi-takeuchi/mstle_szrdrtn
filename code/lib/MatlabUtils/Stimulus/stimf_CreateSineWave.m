function [ SineWave, Time ] = stimf_CreateSineWave( PulseFreq, StartingPhase, Duration, Fs )
% 
%   [ SineWave, Time ] = stimf_CreateSineWave( PulseFreq, StartingPhase, Duration, Fs )
%   PulseFreq: in Hz
%   StartingPhase in pi
%   Duration: in second
%   Fs: sampling rate
%   SineWave: output sine wave
%   Time: in second
%   
% Copyright (c) 2017 Yuichi Takeuchi
%

Time = 0:1/Fs:Duration;
SineWave = sin(2*pi*PulseFreq*Time + StartingPhase);

%
% plot(Time,SquareWave)

