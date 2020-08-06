function [ outputV ] = nidaqf_CalcOutputV_Port1_FT200EMT_45mW( laserpower, WPHTransmission, Nucleo)
%   
%   laserpower: destination power (mW)
%   WPHTransmission: 0.2 - 1.98
%   LaserPower, WPHTransmission
%   outputV: 100 mA/V (direct connection of NIDaq to laser driver)\
%   % in case without Nucleo: 50 mA/V
%   ferrule output is 45 mW / 150 mA when whole LD power
%   calibration: 180621
%   
%   (c) Yuichi Takeuchi 2018

requiredA = 5.0688*...
    laserpower...
    /WPHTransmission...
    /0.96... % cannula transmission rate
    + 30; % inverse mSlope * laserpower *WPHTransmission + threshold of LD

if(Nucleo)
    outputV = requiredA/100;
else
    outputV = requiredA/50;
end
