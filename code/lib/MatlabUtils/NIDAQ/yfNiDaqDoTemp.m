function yfNiDaqDoTemp(DoCh, binaryVector, duration)
%
%   yfNiDaqDo(DoCh, binaryVector)
%   DoCh: string like '0:3'
%   binaryVector: [Do0, Do1, Do2, Do3]
%   duration: time of output in second
%
% Copyright (c) 2017 Yuichi Takeuchi
%

d = daq.getDevices;
s = daq.createSession('ni');
addDigitalChannel(s, d.ID, ['Port0/Line' DoCh],'OutputOnly');

outputSingleScan(s, binaryVector);
pause(duration)
outputSingleScan(s, [0 0 0 0]);

end

