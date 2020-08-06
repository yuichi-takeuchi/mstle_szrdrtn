function [ flag ] = ssf_Poly2_H32_with1A1D( datfilenamebase, nChannels)
%
% [ flag ] = ssf_Poly2_H32_with1A1D( datfilenamebase, nChannels)
%
% INPUTS:
%   datfilenamebase: base name of the .dat file to be read
%   nChannels: total number of recording channels
% 
% Copyright (C) Yuichi Takeuchi 2017

flag = 0;

% Extract the stim waveform channel
disp('extracting a stim waveform channel...')
apf_ExtractChannels([datfilenamebase '.dat'], [datfilenamebase '_stim.dat'],...
                    [33], nChannels);
disp('done.')

% Extract the digital channel
disp('extracting a digital channel...')
apf_ExtractChannels([datfilenamebase '.dat'], [datfilenamebase '_dig.dat'],...
                    [34], nChannels);
disp('done.')

% Extract Channels shank-by-shank from .dat file without stim and digital input channels
disp('extracting analog channels...')
apf_ExtractChannels([datfilenamebase '.dat'], [datfilenamebase '_shk0.dat'],...
                    [8 26 12 22 14 20 16 18 ...
                    3 29 5 27 7 25 11 21 ...
                    13 19 15 17 6 28 4 30 ...
                    2 32 10 24 1 31 9 23], nChannels);
disp('done.')
                
% Remove DC from analog channels file
disp('removing DC shifts from analog channels...')
[returnVar,msg] = RemoveDCfromDat([datfilenamebase '_stim.dat'], 1);
[returnVar,msg] = RemoveDCfromDat([datfilenamebase '_shk0.dat'], (nChannels - 2));
disp('done.')
flag = 1;