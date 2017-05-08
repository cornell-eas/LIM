function [Xanom] = rm_mtx_mean3D(X3D);
%[Xanom] = rm_mtx_mean(X);

dim= size(X3D);
Mu = nanmean(X3D,3);
Xanom = X3D-repmat(Mu,[1 1 dim(3)]);
