function [ flag ] = lfpprepf_ds_lpfltr( srcFileNameBase, src_sr, dstFileNameBase, dst_sr, nChannels)
% 
% Copyright (C) 2020 Yuichi Takeuchi
%

flag = 0;

% Resampling dat file
disp('resampling dat file...')
m = memmapfile([srcFileNameBase '.dat'], 'format', 'int16');
d = m.data;
d = reshape(d, nChannels, []);
dDs = d(:,1:floor(src_sr/dst_sr):end);
[flag] = yfWriteDatFile(dDs,[srcFileNameBase '_DSampled.dat']);

% Low-pass filtering LFP data
disp('Low-pass filtering...')
filtf_LowPassButter1([srcFileNameBase '_DSampled.dat'],...
                    [dstFileNameBase '.dat'],...
                    nChannels,...
                    floor(dst_sr/2),...
                    3,...
                    dst_sr);
% or filtf_LowPassButter2 for previous Matlab version
disp('Low-pass filtering done.')
delete([srcFileNameBase '_DSampled.dat'])
flag = 1;