function [flag] = movf_Downsampling1( srcName, destName, destFR )
%
% INPUTS:
%    srcName: Name string of source file (e.g. 'source.mp4')
%    destName: Name string of destination file (e.g. 'output.avi')
%    destFR: Frame rate of destination file in Hz
% OUTPUT:
%    
%
% Copyright(c) 2019 Yuichi Takeuchi
%

flag = 0;

% input
vin = VideoReader(srcName);
vinFrameNo = floor(vin.Duration*vin.FrameRate);
vin.CurrentTime = 0;
DSFactor = round(vin.FrameRate/destFR);

% output
vout = VideoWriter(destName);
vout.FrameRate = destFR;
open(vout)

% processing
h = waitbar(0, 'processing...');
tic
for i = 1:vinFrameNo
    waitbar(i/vinFrameNo)
    vidFrame = readFrame(vin);
    if mod(i,DSFactor) == 1
        writeVideo(vout, vidFrame);
    end
end
close(vout)
close(h)
toc

flag = 1;



