function [ outputV ] = nidaqf_CalcOutputV_Port1_YTOpto1( laserpower, transmission )
%   
%   laserpower: destination power (mW)
%   transmission: proportion of transmission via a ND filter
%   outputV: 100 mA/V
%   calibration: 170216_exp1_1
%   
%   (c) Yuichi Takeuchi 2017

requiredA = 23.6407*laserpower/transmission + 30; % inverse mSlope * laserpower / transmission + threshold of LD

outputV = requiredA/100;


