function yfNiDaqAiBCont(AiCh, rate)
%
%   yfNiDaqAiBCont(AiCh, rate)
%   AiCh: Vector
%   rate: sampling rate in Hz
%
% Copyright (c) 2015 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');                        % Create a session for National Instruments devices.
s.Rate = rate;
s.IsContinuous = true;

ch = addAnalogInputChannel(s, d.ID, AiCh, 'Voltage');
for i = (1:length(AiCh))
    ch(i).Range = [-10.0 10.0];    % Set the same ragen and terminals for all the channels.
    ch(i).TerminalConfig = 'SingleEnded';   % Configure the terminal and range of the chanels in the session.
end

fid1 = fopen('log.bin','w');

lh = addlistener(s,'DataAvailable',@(src, event)yfplotlogData(src, event, fid1));

s.startBackground();

while s.IsRunning
    pause(0.5)
    fprintf('While loop: Scans acquired = %d\n', s.ScansAcquired)
end

delete(lh)
end
