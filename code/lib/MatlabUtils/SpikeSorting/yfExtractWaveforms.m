function [Waveforms] = yfExtractWaveforms(Filebase, T, varargin)
%
% % ytExtractWaveforms offers matrix of spike waveforms (points, nChannels,
% spikes).
%
%  USAGE
%
%    [Waveforms] = ytExtractWaveforms(Filebase, T, vargin)
%
%    filebase       file to read without extension
%    T              vector of timestamps of spikes
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'frequency'   sampling rate (in Hz, default = 20kHz)
%     'window'      sampling points for each spikes (dafault = 32)
%     'nChannels'   number of data channels in the file (default = 32)
%     'precision'   sample precision (default = 'int16')
%     'Extension'   extension of the file to be read (default = 'dat')
%    =========================================================================
%
% Copyright (C) 2015 by Yuichi Takeuchi


% Default values
sr = 20000;
win = 32;
nChannels = 32;
Precision = 'int16';
Extension = 'dat';

if nargin < 1 || mod(length(varargin), 2) ~= 0,
  error('Incorrect number of parameters (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).');
end

% Parse options
%for i = 1:2:nargin,
%	if ~ischar(varargin{i}),
%		error(['Parameter ' num2str(i+3) ' is not a property (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).']);
%	end
%	switch(lower(varargin{i})),
%		case 'frequency',
%			frequency = varargin{i+1};
%			if ~isscalar(frequency) || frecuency <= 0,
%				error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).');
%           end
%		case 'window',
%			win = varargin{i+1};
%			if ~isscalar(win) || win <= 0
%				error('Incorrect value for property ''window'' (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).');
%            end
%		case 'nchannels',
%			nChannels = varargin{i+1};
%			if ~isscalar(nChannels),
%				error('Incorrect value for property ''nChannels'' (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).');
%            end
%		case 'precision',
%			precision = varargin{i+1};
%			if ~ischar(precision)
%				error('Incorrect value for property ''Precision'' (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).');
%			end
%		case 'extension',
%			Extension = varargin{i+1};
%			if ~ischar(Extension),
%				error('Incorrect value for property ''Extension'' (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).');
%			end
%		otherwise,
%			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help yfExtractWaveforms">yfExtractWaveforms</a>'' for details).']);
%	end
%end

if (length(win) == 1)
    win = [-round(win/2), round(win/2)];
end

nsamples = 2*win(end); % number of sampling points

if isempty(nChannels)
    Par = LoadPar(Filebase); % requires LoadPar.m
    nChannels =Par.nChannels;
end

nT = length(T); % number of time points

Waveforms = zeros(nsamples, nChannels, length(T));

for d = 1:nT
    startpos = (T(d) - win(1))*nChannels*2; % 2 represents sample size (int16 = 2 bytes) 
%    startpos = (T(d) - win(1))*nChannels;
    tmp = bload([Filebase '.' Extension], [nChannels, nsamples], startpos, Precision); % bload.m function will be needed.
    Waveforms(:,:,d) = tmp(:, 1:nsamples)';
%    Waveforms(:,:,d) = tmp(:, 1:nsamples)';
end
