function [C,P] = nancorr(X,varargin)
%Usage: Same as corr, but for matrices with missing values:
%[C,P] = nancorr(X);
%Returns the correlation matrix for X
%
%[C,P] = nancorr(X,Y);
%Returns the correlation matrix betwen the columns of X and the columns of
%Y.



if ~isempty(varargin)
    Y = varargin{1};
    [C,P] = corr(X,Y,'rows','pairwise');
else
    [C,P] = corr(X,'rows','pairwise');
end