function [ outputV ] = nidaqf_CalcOutputV_Port1( laserpower, OpticalCannula)
%   
%   laserpower: destination power (mW)
%   OpticalCannula: 1 or 0
%   outputV: 100 mA/V
%   calibration: 161010_exp1_1
%   
%   (c) Yuichi Takeuchi 2016

if OpticalCannula
    requiredA = 1.162*2.6697*laserpower + 18.4686;
else
    requiredA = 2.6697*laserpower + 18.4686;
end

outputV = requiredA/100;


