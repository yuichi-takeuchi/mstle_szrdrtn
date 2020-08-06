function [ outputV ] = nidaqf_CalcOutputV_Port2( laserpower, OpticalCannula )
%   
%   laserpower: destination power (mW)
%   OpticalCannula: 1 or 0
%   outputV: 100 mA/V
%   calibration: 161010_exp1_1
%   
%   (c) Yuichi Takeuchi 2016

if OpticalCannula
    requiredA = 1.162*3*laserpower + 19.3275;
else
    %requiredA = 2.9808*laserpower + 19.3275;
    requiredA = 3*laserpower + 19.3275;
end

outputV = requiredA/100;