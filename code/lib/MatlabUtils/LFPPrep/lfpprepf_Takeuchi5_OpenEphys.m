function [ flag ] = lfpprepf_Takeuchi5_OpenEphys( datfilenamebase, sr, srLFP, nChannels)
%
% [ flag ] = lfpprepf_Takeuchi5_C3324_LowCut( datfilenamebase, sr, srLFP, nChannels)
%
% This function resamples, DC removes, extracts dig and stim waves from the
% original dat file
%
% INPUTS:
%   datfilenamebase: base name of the .dat file to be read
%   nChannels: total number of recording channels
% 
% Copyright (C) 2020 Yuichi Takeuchi
%

flag = 0;

% Resampling dat file
disp('resampling dat file...')
m = memmapfile([datfilenamebase '.dat'], 'format', 'int16');
d = m.data;
d = reshape(d, nChannels, []);
dDs = d(:,1:floor(sr/srLFP):end);
[flag] = yfWriteDatFile(dDs,[datfilenamebase '_DSampled.dat']);

% Reorganize channels from .dat file without stim and digital input channels
disp('extracting analog channels...')
apf_ExtractChannels([datfilenamebase '_DSampled.dat'],...
                    [datfilenamebase '_reorg.dat'],...
                    [8 9 10 ...    % VTA
                    6 11 12 ...    % AMY CeA
                    13 4 5 ...     % AMY BLA
                    3 14 15 ...    % VP
                    1 16 17 ...    % NAc shell
                    18 31 32 ...   % NAc core
                    30 19 20 ...   % mPFC anterior
                    21 28 29 ...   % mPFC posterior
                    27 22 23 ...   % OFC posterior
                    24 25 26 ...   % OFC anterior
                    7 2],...       % vHPC
                    nChannels);
disp('done.')
                
% Remove DC from analog channels file
disp('removing DC shifts from analog channels...')
[returnVar,msg] = RemoveDCfromDat([datfilenamebase '_reorg.dat'], nChannels);
disp('done.')

% Low-pass filtering LFP data
disp('Low-pass filtering...')
filtf_LowPassButter1([datfilenamebase '_reorg.dat'],...
                    [datfilenamebase '_LFP_reorgtemp.dat'],...
                    (nChannels - 1),...
                    floor(srLFP/2),...
                    3,...
                    srLFP);
% or filtf_LowPassButter2 for previous Matlab version
disp('Low-pass filtering done.')

% High-pass filtering LFP data
disp('High-pass filtering...')
filtf_HighPassButter1([datfilenamebase '_LFP_reorgtemp.dat'],...
                    [datfilenamebase '_LFP_reorg.dat'],...
                    (nChannels - 1),...
                    1,...
                    3,...
                    srLFP);
% or filtf_LowPassButter2 for previous Matlab version
disp('High-pass filtering done.')

% deleting unnecessary files
delete([datfilenamebase '_DSampled.dat'])
delete([datfilenamebase  '_reorg.dat'])
delete([datfilenamebase '_LFP_reorgtemp.dat'])

flag = 1;