function bhf_SineSound( PulseFreq, Duration )
% 
% PulseFreq: in Hz
% Duration: in sec
% 
% Copyright (c) 2017 Yuichi Takeuchi
Fs = 100000;
Time = 0:1/Fs:Duration;
SineWave = sin(2*pi*PulseFreq*Time);
sound(SineWave, Fs);
end

