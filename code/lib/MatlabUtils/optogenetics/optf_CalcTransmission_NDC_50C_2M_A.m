function [ transmission ] = optf_CalcTransmission_NDC_50C_2M_A( angle )
%   
%   angle: should be 45, 135, 180, 225, 270, 315
%
%  copyright (c) 2017 Yuichi Takeuchi

switch angle
    case 45
        transmission = 1;
    case 135
        transmission = 0.3825;
    case 180
        transmission = 0.1524;
    case 225
        transmission = 0.0792;
    case 270
        transmission = 0.0382;
    case 315
        transmission = 0.0208;
    otherwise
        transmission = NaN;
end
    

