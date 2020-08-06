function [ destMat ] = csdf_interp2CSD1( srcMat, XScale, YScale, varargin )
%   INPUTS:
%       srcMat: Time series x Channels
%       XScale: for x interporation
%       YScale: for y interporation
%   Optional inpunt    
%       (Method: String)
%
% Copyright (c) 2016 Yuichi Takeuchi

X = 1-0.5:size(srcMat,2)-0.5;
Y = 1:size(srcMat,1);

[Xq,Yq] = meshgrid((1 + XScale):XScale:(size(srcMat,2)-1),0:YScale:size(srcMat,1));
nVarargs = length(varargin);
if nVarargs
    destMat = interp2(X,Y,srcMat,Xq,Yq);
else
    destMat = interp2(X,Y,srcMat,Xq,Yq,varargin{1});
end


