function [t,ccgR,ccgSM,pt,gb,GSPExc,GSPInh] = unf_CCG_shuffle(spiket,spikeind,clu1,clu2,TrialTSRFOffset,ccgBinSize,ccgHalfBins)
%
%   [t,ccgR,ccgSM,pt,gb,GSPExc,GSPInh] = unf_CCG_shuffle(spiket,spikeind,clu1,clu2,TrialTSRFOffset,ccgBinSize,ccgHalfBins)
% Shuffling method is "single-spike-trial-shuffling (Poisson)"
% ccgR: ccg real
% ccgSM: ccg shuffle mean
% pt = [pMax(:), pMin(:)];
% gb = [gMax(:), pMin(:)];
%
% Copyright (C) 2017 Yuichi Takeuchi
% inspired by Shigeyoshi Fujisawa

if nargin < 6
   ccgBinSize  = 20;
   ccgHalfBins = 50;
end

nshuff = 200;
Alpha = 0.05;

res1 = spiket(spikeind == clu1);
res2 = spiket(spikeind == clu2);
nTrial = length(TrialTSRFOffset);

% Time alignment at trail start time
res1_atime = [];  % aligned time
res2_atime = [];  % aligned time
res1_label = [];
res2_label = [];

for i = 1:nTrial
    TrialStart = TrialTSRFOffset(i,1);
    TrialEnd   = TrialTSRFOffset(i,2);
    DatOffset = TrialTSRFOffset(i,3);
     
    findres1 = find((res1 >= TrialStart + DatOffset) & (res1 < TrialEnd + DatOffset));
    findres2 = find((res2 >= TrialStart + DatOffset) & (res2 < TrialEnd + DatOffset));

    res1_atime  = [res1_atime ; res1(findres1) - TrialStart - DatOffset];
    res1_label  = [res1_label ; i*ones(length(findres1),1)];

    res2_atime  = [res2_atime ; res2(findres2) - TrialStart - DatOffset];
    res2_label  = [res2_label ; i*ones(length(findres2),1)];
end

% Real CCG
res1_real =[];
res2_real =[];
for i = 1:nTrial
    TrialStart = TrialTSRFOffset(i,1);
    DatOffset = TrialTSRFOffset(i,3);
    res1_thistrial = res1_atime(res1_label == i) + TrialStart + DatOffset;
    res2_thistrial = res2_atime(res2_label == i) + TrialStart + DatOffset;
    res1_real = [res1_real;res1_thistrial];
    res2_real = [res2_real;res2_thistrial];
end

res_this  = [res1_real ; res2_real];
clu_this  = [ones(length(res1_real),1) ; 2*ones(length(res2_real),1) ];

[ccg,t,~,~] = CCG(double(res_this), clu_this, ccgBinSize, ccgHalfBins, 20000, [1 2],'count',[]);
ccgR = ccg(:,1,2);
% auto_real_1 = ccg(:,1,1);
% auto_real_2 = ccg(:,2,2);

% Shuffle
for shuff = 1:nshuff
%     disp(['shuffling ' num2str(shuff)])
    res1_label_shuff = res1_label(randperm(length(res1_label)));
    res2_label_shuff = res2_label(randperm(length(res2_label)));

    res1_shuff =[];
    res2_shuff =[];
    for i = 1:nTrial
        TrialStart = TrialTSRFOffset(i,1);
        DatOffset = TrialTSRFOffset(i,3);
        res1_thistrial = res1_atime(res1_label_shuff == i) + TrialStart + DatOffset;
        res2_thistrial = res2_atime(res2_label_shuff == i) + TrialStart + DatOffset;
        res1_shuff = [res1_shuff;res1_thistrial];
        res2_shuff = [res2_shuff;res2_thistrial];
    end
    res_this  = [res1_shuff ; res2_shuff];
    clu_this  = [ones(length(res1_shuff),1) ; 2*ones(length(res2_shuff),1) ];

    [ccg,t,~,~] = CCG(double(res_this), clu_this, ccgBinSize, ccgHalfBins, 20000,[1 2],'count', []);
    ccgs(:,shuff) = ccg(:,1,2);
    ccgsmax(shuff) = max(ccgs(:,shuff));
    ccgsmin(shuff) = min(ccgs(:,shuff));
end

%%%%%%  Compute the pointwise line
signifpoint = nshuff*Alpha;
for i = 1:length(t)
    sortshuffleDescend  = sort(ccgs(i,:),'descend');
    sortshuffleAscend   = sort(ccgs(i,:),'ascend');
    ccgsptMax(i) = sortshuffleDescend(signifpoint);
    ccgsptMin(i) = sortshuffleAscend(signifpoint);
end
pt = [ccgsptMax', ccgsptMin'];

%%%%%%  Compute the global line
sortgbDescend   = sort(ccgsmax,'descend');
sortgbAscend    = sort(ccgsmin,'ascend');
ccgsgbMax  = sortgbDescend(signifpoint)*ones(size(t));
ccgsgbMin  = sortgbAscend(signifpoint)*ones(size(t));
gb = [ccgsgbMax', ccgsgbMin'];

%%%%%% Mean
ccgSM  = mean(ccgs,2);

%%%%%% Find significant period 
findExc = ccgR > ccgsgbMax' & ccgR > 0;
findInh = ccgR < ccgsgbMin' & ccgsgbMin' > 0;

GSPExc = zeros(size(t));  % Global Significant Period of Excitation
GSPInh = zeros(size(t));  % Global Significant Period of Inhibition

GSPExc(findExc) = 1;
GSPInh(findInh) = 1;

