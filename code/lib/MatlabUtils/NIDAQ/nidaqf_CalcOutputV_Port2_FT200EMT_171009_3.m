function [ outputV ] = nidaqf_CalcOutputV_Port2_FT200EMT_171009_3( laserpower, WPHTransmission )
%   
%   laserpower: destination power (mW)
%   WPHTransmission: 0.2 - 1.98
%   LaserPower, WPHTransmission
%   outputV: 100 mA/V (with Nucleo)
%   ferrule output is 47 mW / 150 mA when whole LD power
%   calibration: 171009
%   
%   (c) Yuichi Takeuchi 2017

requiredA = 5.055...
    *laserpower...
    /WPHTransmission...
    /0.96... % cannula transmission rate
    + 30; % inverse mSlope * laserpower *WPHTransmission + threshold of LD

outputV = requiredA/100;
