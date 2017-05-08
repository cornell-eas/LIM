function [Pxx,f,PxxClv95] = mtmspec(x,nf,plotopt,varargin)
%Usage:
%[Pxx,f] = mtmspec(x,nf,plotopt)

if length(varargin)>0
    method=varargin{1};
else
    method='adapt';
end

[nt,ns] = size(x);
for i = 1:ns
%    q = find(~isnan(x(:,i)));
%     xq = x(q,i);
%     
%     xq = xq-nanmean(xq);
%     xq(find(isnan(xq))) = 0;
%    [Pxx(:,i),PxxClv95,w] = pmtm(xq,2,nf);
    xanom=x(:,i)-nanmean(x(:,i));
    xanom(isnan(xanom))=0;
    
    [Pxx(:,i),PxxClv95,w] = pmtm(xanom,2,nf,method);

    f = w./(2*pi);
end

if plotopt ==1
    hold on
    plot(f,Pxx)
%     plot(f,PxxClv95,'y')
    set(gca,'XLim',[0 .5])
else end
