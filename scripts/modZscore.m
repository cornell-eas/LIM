function z=modZscore(time,tedges,X)
%z=modZscore(time,tedges,X)
% X can be 1D or 2D

tq=find(time>=tedges(1) & time<=tedges(2));
z=nan(size(X));
for i=1:size(X,2);
    x=X(:,i);
    mn=nanmean(x(tq));
    std=nanstd(x(tq));
    z(:,i)=(x-mn)./std;
end