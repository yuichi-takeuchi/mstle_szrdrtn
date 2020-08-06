function [t,ccg_real,ccg_shuff_mean,pt,gb,signif_area] = unf_SignificantPeakDetection(spiket,spikeind,clu1,clu2,TrialTSRFOffset,ccgBinSize,ccgHalfBins)
%
% Shuffling method is "single-spike-trial-shuffling (Poisson)"
% 

tic;
if nargin < 6
   ccgBinSize  = 20;
   ccgHalfBins = 50;
end

presen_boolen = 1;

% gaussvar = 0.05^2;
% bin_size = 0.01;
nshuff = 4000;

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

    clear findres1;
    clear findres2;
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
ccg_real = ccg(:,1,2);
auto_real_1 = ccg(:,1,1);
auto_real_2 = ccg(:,2,2);

% %% temp
% ccg_shuff_mean = nan;
% pt = nan;
% gb = nan;
% signif_area = nan;

% Shuffle
for shuff = 1:2*nshuff
    disp(shuff)
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
    ccg_shuff(:,shuff) = ccg(:,1,2);
end

% Pointwise and Global
ccg_shuff_1 = ccg_shuff(:,1:nshuff);
ccg_shuff_2 = ccg_shuff(:,(nshuff+1):(2*nshuff));

ccg_shuff_mean = mean(ccg_shuff,2);

% ...Pointwise
alpha  = 0.05; 
alphaR = 1/alpha;

for i = 1:floor(nshuff/alphaR)
   pt_temp(:,i) = max(ccg_shuff_1(:,(1+(i-1)*alphaR):(i*alphaR)),[],2);
end
pt = mean(pt_temp,2);

clear pt_temp

% ...Global
for nshuff_local = alphaR:100:(nshuff/2)
    for i = 1:2
       pt_temp(:,i) = max(ccg_shuff_1(:,(1+(i-1)*nshuff_local):(i*nshuff_local)),[],2);
    end
    gb_temp = mean(pt_temp,2);
    clear pt_temp;

    num_break = 0;
    for k=1:nshuff
        subtra = gb_temp - ccg_shuff_2(:,k);
        if any(subtra<=0)
            num_break = num_break+1;
        end
    end
    break_ratio = num_break/nshuff;
    if(break_ratio<=alpha)
        gb = gb_temp;
        nshuff_local;
        1/nshuff_local;
        break
    end
end
if break_ratio > 0.05
    'Caution!!! global';
    gb = max(ccg_shuff,[],2);
end

%%% Global Coservative

% Significant Area
d_pt = ccg_real - pt;
d_gb = ccg_real - gb;
signif_area_pt = zeros(length(d_pt),1);

area_number = 0;
if d_pt(1)>=0
    area_number = 1;
end
for i=1:length(d_pt)
   if d_pt(i)>=0
      signif_area_pt (i) = area_number;
   end
   if i<length(d_pt)
      if (d_pt(i+1)>=0)&(d_pt(i)<0) 
         area_number = area_number + 1;
      end
   end
end
signif_area_gb = signif_area_pt;
if area_number>=1
  for area_i=1:max(signif_area_pt)
      findarea = find(signif_area_pt == area_i);
      if (~any(d_gb(findarea)>=0))
         signif_area_gb(findarea)=0;
      end
  end
end

signif_area = zeros(length(d_pt),1);
signif_area(find(signif_area_gb>0)) =  1 ;

toc

% Presentation
if presen_boolen == 1
    subplot(2,2,1)
    plot(t,auto_real_1,'color','k')
    subplot(2,2,2)
    plot(t,ccg_real,'color','k')
    line(t,ccg_shuff_mean,'linestyle','--','color','b')
    line(t,pt,'linestyle','--','color','r')
    line(t,gb,'linestyle','--','color','m')
    subplot(2,2,4)
    plot(t,auto_real_2,'color','k')
    subplot(2,2,3)
    imagesc(signif_area')
    set(gca,'Clim',[-1.4,1.4])
end