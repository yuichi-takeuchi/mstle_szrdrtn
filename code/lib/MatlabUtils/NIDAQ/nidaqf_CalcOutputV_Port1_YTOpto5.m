function [ outputV ] = nidaqf_CalcOutputV_Port1_YTOpto5( laserpower, WPHTransmission, NDCTransmission )
%   
%   laserpower: destination power (mW)
%   WPHTransmission: 
%   NDCTransmission: proportion of transmission via a ND filter
%   LaserPower, WPHTransmission, NDCTransmission
%   outputV: 100 mA/V
%   calibration: 170427
%   
%   (c) Yuichi Takeuchi 2017

requiredA = 237.6...
    *laserpower...
    /WPHTransmission...
    /NDCTransmission...
    + 30; % inverse mSlope * laserpower *WPHTransmission / NDCTransmission + threshold of LD

outputV = requiredA/100;


