function [ DestMat ] = apf_AmplipexToOrganized_H32_Linear32(SrcMat)

SiteVec = [9,23,1,31,10,24,2,32,...
            4,30,6,28,8,26,12,22,...
            14,20,16,18,3,29,5,27,...
            7,25,11,21,13,19,15,17];
DaetMat = zeros(length(SrcMat), length(SiteVec));
for k = 1:length(SiteVec)
    DestMat(:,k) = SrcMat(:, SiteVec(k));
end