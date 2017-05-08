function Ctau=lagCov(X,Y,tau);
% Ctau=lagCov(X,Y,tau);
% Computes lag covariance matrix of X following Equation 5. of 
% Penland and Sardesmukh, 1995.
% 
% Use lagCov(X,X,tau) for X lag-covariance matrix, lagCov(X,Y,tau) for
% lag covariance of X with Y. 
% 
% Notes:
% - length(X,1) must equal length(Y,1);
% - X,Y must be dimension nt x nSites

% chech shapes:
ntX=size(X,1);
ntY=size(Y,1);
if ntY~=ntX
    error('ntY~=ntX')
end
nt=ntX;

% remove means:
X=rm_mtx_mean(X(1+tau:end,:));
Y=rm_mtx_mean(Y(1:end-tau,:));
Ctau=(X'*Y)./nt;


