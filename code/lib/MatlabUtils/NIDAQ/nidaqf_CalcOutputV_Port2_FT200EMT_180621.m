function [ outputV ] = nidaqf_CalcOutputV_Port2_FT200EMT_180621( laserpower, WPHTransmission )
%   
%   laserpower: destination power (mW)
%   WPHTransmission: 0.2 - 1.98
%   LaserPower, WPHTransmission
%   outputV: 30 mA/V (direct connection of NIDaq to laser driver without Nucleo)
%   ferrule output is 30 mW / 150 mA when whole LD power
%   calibration: 180621
%   
%   (c) Yuichi Takeuchi 2018

requiredA = 8*...
    laserpower...
    /WPHTransmission...
    /0.96... % cannula transmission rate
    + 30; % inverse mSlope * laserpower *WPHTransmission + threshold of LD

outputV = requiredA/50;
