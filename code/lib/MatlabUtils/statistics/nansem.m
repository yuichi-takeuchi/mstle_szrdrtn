function y=nansem(x)
nonanx=x(~isnan(x));
y=std(nonanx) / sqrt(size(nonanx,2));
end