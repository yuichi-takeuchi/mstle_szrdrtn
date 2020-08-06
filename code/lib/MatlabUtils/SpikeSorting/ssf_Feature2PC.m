function [ PC, EV ] = ssf_Feature2PC( Feature )
%
% [ PC, EV ] = ssf_Feature2PC( Feature )
%
% INPUTS:
%   Feature = 2 x 24 x nSpikes
%
% OUTPUS:
%   PC: The first three principal componets
%   EV: Eigen values of the three PCs
%
% Copyright (C) Yuichi Takeuchi 2017
%

% Making vector D for PCA
% Feature: [(a*b)*nSpikes] single
% C is vectorized values of (a*b)
% D has C of n th spikes in the n th row

% Getting size of Feature and preallocating of D
[a,b,nSpikes]=size(Feature);
D = zeros(nSpikes,a*b);

% Making D
for i = 1:nSpikes
    A = Feature(:,:,i);
    D(i,:) = A(:)';
end

% PCA of D
[~,score,latent] = pca(D);
PC = score(:,[1:3]);

% Calculating Eigen value
SumLatent = sum(latent);
EV(1) = latent(1)/SumLatent*100;
EV(2) = latent(2)/SumLatent*100;
EV(3) = latent(3)/SumLatent*100;

