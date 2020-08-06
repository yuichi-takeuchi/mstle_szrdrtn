function [flag] = movf_WriteFrames1( srcName, destNameBase )
%
% INPUTS:
%    srcName: Name string of source file (e.g. 'source.mp4')
%    destNameBase: Base string of destination files (e.g. 'frame')
% OUTPUT:
%    flag: 1 with successful end
%
% Copyritght(c) 2019 Yuichi Takeuchi
%

flag = 0;

% input
vin = VideoReader(srcName);
vinFrameNo = floor(vin.Duration*vin.FrameRate);
vin.CurrentTime = 0;

% Writing images
h = waitbar(0, 'processing...');
tic
for i = 1:vinFrameNo
    waitbar(i/vinFrameNo)
    vidFrame = readFrame(vin);
    imwrite(vidFrame, [destNameBase num2str(i) '.png']);
end
mkdir('frame')
movefile([destNameBase '*.png'], 'frame')
close(h)
toc

flag = 1;



