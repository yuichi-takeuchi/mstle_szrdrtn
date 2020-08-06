function [ outputV ] = nidaqf_CalcOutputV_Port2_FT200EMT_170829_1( laserpower, WPHTransmission )
%   
%   laserpower: destination power (mW)
%   WPHTransmission: 0.2 - 1.98
%   LaserPower, WPHTransmission
%   outputV: 100 mA/V
%   ferrule output is 56 mW / 150 mA when whole LD power
%   calibration: 170829
%   
%   (c) Yuichi Takeuchi 2017

requiredA = 4.37...
    *laserpower...
    /WPHTransmission...
    /0.41... % cannula transmission rate
    + 30; % inverse mSlope * laserpower *WPHTransmission + threshold of LD

outputV = requiredA/100;
