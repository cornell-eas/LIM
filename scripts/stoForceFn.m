function XrandMo=stoForceFn(Xinit,B,Qscld,nQeigs,nMo,deltaT,moLen,nMoExtra)

nq=length(B);
y=nan(nq,moLen+1);
% y(:,1)=zeros(nq,1);
y(:,1)=Xinit;
xRnd=nan(nq,moLen);

for j =1:nMo+nMoExtra;
    for i =2:moLen+1;
        r=randn(nQeigs,1);    
        y(:,i)=(eye(size(B))+B*deltaT)*y(:,i-1)+sqrt(deltaT)*Qscld*r;
        xRnd(:,i-1)=(y(:,i-1)+y(:,i))/2;
    end

    % average xRnd to XrandMo
    XrandMo(:,j)=real(mean(xRnd,2));        

    % and re-initialize y
    yEnd=y(:,i);
%         clear y xRnd
    y=nan(nq,moLen+1);
    xRnd=nan(nq,moLen);        
    y(:,1)=yEnd;
end
XrandMo(:,1:nMoExtra)=[];
