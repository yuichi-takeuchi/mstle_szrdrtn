function [ flag ] = lfpprepf_Takeuchi3_with1A1D( datfilenamebase, sr, srLFP, nChannels)
%
% [ flag ] = lfpprepf_Takeuchi3_with1A1D( datfilenamebase, sr, srLFP, nChannels)
%
% This function resamples, DC removes, extracts dig and stim waves from the
% original dat file
%
% INPUTS:
%   datfilenamebase: base name of the .dat file to be read
%   nChannels: total number of recording channels
% 
% Copyright (C) Yuichi Takeuchi 2017
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
                    [2 1 3 ...
                    5 6 4 ...
                    8 7 9 ...
                    11 12 10 ...
                    14 13 15 ...
                    17 16 18 ...
                    20 21 19 ...
                    23 22 24 ...
                    26 25 27 ...
                    29 30 28],...
                    nChannels);
disp('done.')

% Extract the stim waveform channel
disp('extracting a stim waveform channel...')
apf_ExtractChannels([datfilenamebase '_DSampled.dat'],...
                    [datfilenamebase '_adc.dat'],...
                    [31],...
                    nChannels);
disp('done.')

% Extract the digital channel
disp('extracting a digital channel...')
% [ DigCh ] = fileiof_getChannelsFromBinary1( [datfilenamebase '.dat'], 32, nChannels );
% DigDS = DigCh(1:floor(sr/srLFP):end);
% [flag] = yfWriteDatFile(DigDS,[datfilenamebase '_dig.dat']);
apf_ExtractChannels([datfilenamebase '_DSampled.dat'],...
                    [datfilenamebase '_dig.dat'],...
                    [32],...
                    nChannels);
disp('done.')
                
% Remove DC from analog channels file
disp('removing DC shifts from analog channels...')
[returnVar,msg] = RemoveDCfromDat([datfilenamebase '_adc.dat'], 1);
[returnVar,msg] = RemoveDCfromDat([datfilenamebase '_reorg.dat'], (nChannels - 2));
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