function [Xanom] = rm_mtx_mean(X);
%[Xanom] = rm_mtx_mean(X);

[nt,ns] = size(X);
Mu = nanmean(X);
Xanom = X-repmat(Mu,nt,1);