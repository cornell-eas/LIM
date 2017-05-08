function [C2D,P2D] =  corr3D(ts,X3D)
%Usage:
%C =  corr3D(ts,X3D)
%
%Requires that dim(X3D,3) == length(ts);
[n,m,nt] = size(X3D);

X2D = reshape(X3D,n*m,nt)';
[C1D,P1D] = AdjDOF95(ts,X2D);
C2D = reshape(C1D',n,m);
P2D = reshape(P1D',n,m);

function [C, Sig,Praw,NullVal,AR1x,AR1y] = AdjDOF95(x,Y);
%  [C, Sig,Praw,NullVal,AR1x,AR1y] = AdjDOF95(x,Ymtx);
%
%Returns the correlation coefficient between x (a single column vector) and
%Ymtx (a vector or Matrix) along with a 1 or 0 indicating weather the
%correlation coefficient is signfificant
q= find(sum(~isnan(Y)) ~=0);
Ymtx = Y(:,q);

%correlation between x and Ymtx:
C = nan(1,size(Y,2));
Praw = nan(size(C));
[C(q),Praw(q)] = corr(x,Ymtx,'rows','pairwise');

%number of observations (unadjusted DOF, but accounting for NaNs)
Nx = sum(~isnan(x));
NYmtx = sum(~isnan(Ymtx));

%Autocorrelation coefficient for x
AR1x = corr(x(1:end-1),x(2:end),'rows','pairwise');
AR1y = nan(1,size(Y,2));
for i = 1:length(q)
    AR1y(q(i)) = corr(Ymtx(1:end-1,i),Ymtx(2:end,i),'rows','pairwise');
end

%Adjusted DOF for x - Ymtx correlation:
Nprime = nan(1,size(Y,2));
Nprime(q) = NYmtx.*[1-[AR1x .* AR1y(q)]]./[1+[AR1x .* AR1y(q)]];

%95% confidence values for accepting the Null hypothesis:
NullVal = nan(2,size(Y,2));
NullVal(:,q) = [-1.96./sqrt([Nprime(q)-2]); 1.96./sqrt([Nprime(q)-2])];


%Locations where corelation is less than/greater than Null value:
Sig = nan(size(AR1y));
Sig = [C <= NullVal(1,:) | C>= NullVal(2,:)];
