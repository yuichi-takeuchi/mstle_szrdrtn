function [ destMat ] = apf_ScaleUnitV( srcMat, RecGain, bitRes, VRange, OutGain)
%
%   Inputs
%       srcMat: Voltage recording
%       RecGain: Recording gain
%       bitRes: bit resolution of ADC
%       VRange: +-range of ADC
%       OutGain: 1 for V, 1e3 for mV, 1e6 for uV
%
%   Output
%       destMat: scaled in V
%
%   (c) Yuichi Takeuchi 2016

Resolution = 2^bitRes;
Scale = OutGain*VRange/(RecGain*Resolution);
destMat = double(srcMat)*Scale;




