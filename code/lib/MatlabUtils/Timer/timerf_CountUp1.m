function timerf_CountUp1( timeout )
%
%   timerf_CountUp1( timeout )
%
%   INPUT
%   timeout: time for count up in second
%
% Copyright (c) 2018 Yuichi Takeuchi
%

tStart = tic;
eTime = 0;
counter = 0;

while(eTime < timeout)
    pause(1)
    counter = counter + 1;
    disp([num2str(counter) ' s'])
    eTime = toc(tStart);
end


