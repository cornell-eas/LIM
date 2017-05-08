function p= lines2patch(x,y,varargin)
%p= lines2patch(x,y,varargin);

xData=[x; flipud(x)];
U=sort(y')';
Uedge=[U(:,1); flipud(U(:,end))];
nanq=isnan(Uedge) | isinf(1./xData);

Uedge(nanq)=[];
xData(nanq)=[];
varargin{:};
p=patch(xData,Uedge,varargin{:});


