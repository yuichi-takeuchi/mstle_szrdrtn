function [ flag ] = lfpprepf_Takeuchi1_with1A1D( datfilenamebase, sr, srLFP, nChannels)
%
% [ flag ] = lfpprepf_Takeuchi1_with1A1D( datfilenamebase, nChannels)
%
% This function resamples, DC removes, extracts dig and stim waves from the
% original dat file
%
% INPUTS:
%   datfilenamebase: base name of the .dat file to be read
%   nChannels: total number of recording channels
% 
% Copyright (C) 2017 Yuichi Takeuchi
%

flag = 0;

% Resampling dat file
disp('resampling dat file...')
ResampleBinary([datfilenamebase '.dat'],...
                [datfilenamebase '_DSampled1.dat'],...
                nChannels,...
                1,...
                floor(sr/srLFP));
disp('done')

% Extract the stim waveform channel
disp('extracting a stim waveform channel...')
apf_ExtractChannels([datfilenamebase '_DSampled1.dat'],...
                    [datfilenamebase '_stim.dat'],...
                    [19],...
                    nChannels);
disp('done.')

% Extract the digital channel
disp('extracting a digital channel...')
[ DigCh ] = fileiof_getChannelsFromBinary1( [datfilenamebase '.dat'], 20, nChannels );
DigDS = DigCh(1:floor(sr/srLFP):end);
[flag] = yfWriteDatFile(DigDS,[datfilenamebase '_dig.dat']);
% apf_ExtractChannels([datfilenamebase '_DSampled1.dat'],...
%                     [datfilenamebase '_dig.dat'],...
%                     [32],...
%                     nChannels);
disp('done.')

% Reorganize channels from .dat file without stim and digital input channels
disp('extracting analog channels...')
apf_ExtractChannels([datfilenamebase '_DSampled1.dat'],...
                    [datfilenamebase '_reorg.dat'],...
                    [2 1 3 ...
                    5 6 4 ...
                    8 7 9 ...
                    11 12 10 ...
                    14 13 15 ...
                    17 18 16 ...
                    ],...
                    nChannels);
disp('done.')
                
% Remove DC from analog channels file
disp('removing DC shifts from analog channels...')
[returnVar,msg] = RemoveDCfromDat([datfilenamebase '_stim.dat'], 1);
[returnVar,msg] = RemoveDCfromDat([datfilenamebase '_reorg.dat'], (nChannels - 2));
disp('done.')

% Low-pass filtering LFP data
disp('Low-pass filtering...')
filtf_LowPassButter1([datfilenamebase '_reorg.dat'],...
                    [datfilenamebase '_LFP_reorg.dat'],...
                    (nChannels - 2),...
                    floor(srLFP/2),...
                    3,...
                    srLFP);
% or filtf_LowPassButter2 for previous Matlab version
disp('Low-pass filtering done.')

% deleting unnecessary files
delete([datfilenamebase '_DSampled1.dat'])
delete([datfilenamebase  '_reorg.dat'])

flag = 1;