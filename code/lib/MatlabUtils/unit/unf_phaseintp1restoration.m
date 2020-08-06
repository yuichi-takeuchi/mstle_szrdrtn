function [ InstantaneousPhase ] = unf_phaseintp1restoration( HighResTS, PhaseDS, AlignedRes )
%
% restores high time resolution instantaneous phase from downsampled phase
% vector and high resolution timestamp
% [ InstantaneousPhase ] = unf_phaseintp1restoration( HighResTS, PhaseDS, AlignedRes )
% 
%   HighResTS: High resolution timestamp
%   PhaseDS: instantaneous phase from downsampled LFP data
%   AlignedRes: High resolution timestamps of units, aligned
%
% Copyright (C) 2017 Yuichi Takeuchi

LowResTS = linspace(1, HighResTS(end), length(PhaseDS));
PhaseRS = interp1(LowResTS,PhaseDS,HighResTS, 'nearest');
% PhaseRSN = interp1(LowResTS,PhaseDS,HighResTS, 'next');
% PhaseRSP = interp1(LowResTS,PhaseDS,HighResTS, 'previous');
% [PhaseRS,~,~] = circ_mean([PhaseRSN;PhaseRSP]);
InstantaneousPhase = PhaseRS(AlignedRes);
end

