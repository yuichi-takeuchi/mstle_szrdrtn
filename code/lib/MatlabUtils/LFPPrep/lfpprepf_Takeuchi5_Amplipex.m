function [ flag ] = lfpprepf_Takeuchi5_Amplipex( datfilenamebase, sr, srLFP, nChannels)
%
% [ flag ] = lfpprepf_Takeuchi5( datfilenamebase, sr, srLFP, nChannels)
%
% This function resamples, DC removes from the
% original dat file
%
% INPUTS:
%   datfilenamebase: base name of the .dat file to be read
%   sr: sampling rate of original dat
%   srLFP: sampling rate of destination dat
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
                    [2 1 3 ...  % VTA
                    6 5 7 ...   % CeA
                    9 10 8 ...  % BLA
                    12 11 13 ...    % VP
                    16 15 17 ...    % NAc shell
                    19 20 18 ...    % NAc core
                    22 21 23 ...    % mPFC anterior
                    25 26 24 ...    % mPFC posterior
                    28 27 29 ...    % OFC posterior
                    31 32 30 ...    % OFC anterior
                    4 14],...       % vHPC
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