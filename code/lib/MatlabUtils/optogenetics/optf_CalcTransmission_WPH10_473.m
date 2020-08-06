function [ transmission ] = optf_CalcTransmission_WPH10_473( port, angle )
%   
%   port: should be 1 or 2
%   angle: should be 0, 22.5, 45, 67.5, or 90
%
%  Copyright (c) 2017 Yuichi Takeuchi

switch angle
    case 0
        transmission = 1.98;
    case 22.5
        transmission = 1;
    case 45
        transmission = 0.02;
    case 67.5
        transmission = 1;
    case 90
        transmission = 1.98;
    otherwise
        transmission = NaN;
end

if port == 2
    transmission = 2 - transmission;
end