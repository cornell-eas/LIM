function istr=ind2str(i,ndigits);
% istr=ind2str(i,ndigits);
basestr=repmat('0',[1 ndigits]);
istr=basestr;
strlen=length(num2str(i));
istr(end-strlen+1:end)=num2str(i);