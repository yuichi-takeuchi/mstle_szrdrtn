function [ outputV ] = nidaqf_CalcOutputV_Port1_YTOpto6( laserpower, WPHTransmission, NDCTransmission )
%   
%   laserpower: destination power (mW)
%   WPHTransmission: 0.2 - 1.98
%   NDCTransmission: proportion of transmission via a ND filter
%   LaserPower, WPHTransmission, NDCTransmission
%   probe tip output is 3.3 mW / 150 mA when whole LD power
%   outputV: 100 mA/V
%   calibration: 170619
%   
%  Copyright (c) 2017 Yuichi Takeuchi
%

requiredA = 67.9...
    *laserpower...
    /WPHTransmission...
    /NDCTransmission...
    + 30; % inverse mSlope * laserpower *WPHTransmission / NDCTransmission + threshold of LD

outputV = requiredA/100;


