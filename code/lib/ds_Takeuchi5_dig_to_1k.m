function ds_Takeuchi5_dig_to_1k(ID,date)
%   ytake 2020

%% meta infomation
%%
% ID = 'yt2';
% date = 20200522;
metaInfo = struct(...
    'expNo', 1,...
    'sessionNo', 1,...
    'datFileNameBase', [ID '_' num2str(date) '_exp' ],...
    'nChannels', 33,...
    'sr', 20000,...
    'srLFP', 1000 ...
    );
clear ID date
%% path

addpath(genpath('helper'))
addpath(genpath('lib'))
%% dat file preparations
%%
% move to data folder
currentFolder = pwd;
cd('../data/')

% processing
disp('dat file preparations...');tic
datFileNameBase = [metaInfo.datFileNameBase num2str(metaInfo.expNo) '_' num2str(metaInfo.sessionNo) ];
if(exist([datFileNameBase '.dat'],'file'))
disp(['processing ' datFileNameBase '.dat'])
[ flag ] = lfpprepf_Takeuchi5_Amplipex_with1D(datFileNameBase, metaInfo.sr, metaInfo.srLFP, metaInfo.nChannels);
fprintf('flag = %d', flag)
end
disp('processing done'); toc

% move files to results folder
movefile([datFileNameBase '_LFP_reorg.dat'], ['../results/' datFileNameBase '_LFP1k.dat']);
movefile([datFileNameBase '_dig.dat'], ['../results/' datFileNameBase '_dig1k.dat']);

% come back to current folder
cd(currentFolder)

clear currentFolder flag

%% Output of tsp of digital channel
%%
% memory mapping
mdig = memmapfile(['../results/' datFileNameBase '_dig1k.dat'], 'format', 'int16');
digch = mdig.data';
clear mdig

% Get binary vector
digBinaryVector = logical(decimalToBinaryVector(digch, 4, 'LSBFirst')); 
[~,tempR,~] = ssf_FindConsecutiveTrueChunks(digBinaryVector(:,1)');
tsp_pulse_ephys = uint32((tempR - 1)*1000/metaInfo.srLFP); % in millisecond
save(['../results/' datFileNameBase '_rsync_1k_tsp.mat'], 'tsp_pulse_ephys', '-v7.3')

clear mdig digch digBinaryVector tempR tempF

end

