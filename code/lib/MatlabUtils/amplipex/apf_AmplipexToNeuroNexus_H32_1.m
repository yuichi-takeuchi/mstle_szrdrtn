function [ DestMat ] = apf_AmplipexToNeuroNexus_H32_1(SrcMat)

SiteVec = [17,19,21,25,27,29,18,20,...
            22,26,28,30,32,24,31,23,...
            9,1,10,2,4,6,8,12,...
            14,16,3,5,7,11,13,15];
DaetMat = zeros(length(SrcMat), length(SiteVec));
for k = 1:length(SiteVec)
    DestMat(:,k) = SrcMat(:, SiteVec(k));
end