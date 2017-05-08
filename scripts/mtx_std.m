function [NormX,ColStd,MtxSigma]  = mtx_std(X);
%[NormX,ColStd,MtxSigma]  = mtx_std(X);

X = rm_mtx_mean(X);
[nt,ns] = size(X);
ColStd = nanstd(X);
MtxSigma = repmat(ColStd,nt,1);
NormX = X./MtxSigma;