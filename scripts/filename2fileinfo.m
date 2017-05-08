function [varname,realm,modid,expid,runid,yrStart,moStart,yrEnd,moEnd]=filename2fileinfo(filename);
% [varname,realm,modid,expid,runid,yrStart,moStart,yrEnd,moEnd]=filename2fileinfo(filename);

%pr_Amon_CCSM4_historical_r1i2p1_185001-200512.nc
% [1]  [2]   [3]        [4]    [5]
q_=find(filename=='_');
varname=filename(1:q_(1)-1);
realm=filename(q_(1)+1:q_(2)-1);
modid=filename(q_(2)+1:q_(3)-1);
expid=filename(q_(3)+1:q_(4)-1);
runid=filename(q_(4)+1:q_(5)-1);

datestr=filename(q_(5)+1:q_(5)+13);
yrStart=eval(datestr(1:4));
moStart=eval(datestr(5:6));
yrEnd=eval(datestr(8:11));
moEnd=eval(datestr(12:13));

