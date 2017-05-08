function ncstruct=nc2struct(ncfile,varargin)
% ncstruct=nc2struct(ncfile,variable_names)
% % if variable_names is blank, all are returned

if nargin==1
    varnames=ncgetvar_names(ncfile);
else
    varnames=varargin;
end



ncid=netcdf.open(ncfile,'NOWRITE');

varnums=netcdf.inqDimIDs(ncid);
for i =1:length(varnums)
    [dimname,dimlen]=netcdf.inqDim(ncid,varnums(i));
    eval(['ncstruct.dims.' dimname '= dimlen;'])   
    alldims{i}=dimname;
end

for i =1:length(varnames);
   varnum=netcdf.inqVarID(ncid,varnames{i});
   [varname,vartype,vardimids,nvaratts]= netcdf.inqVar(ncid,varnum);
   vn=varnames{i};
   vn(vn==' ')='_';
   vn(vn=='-')='_';
   varnames{i}=vn;
   eval(['ncstruct. ' varnames{i} '.data=double(netcdf.getVar(ncid,varnum));']);
   eval(['ncstruct. ' varnames{i} '.dim_names=alldims(vardimids+1);']);
   for j=1:nvaratts
       attname=netcdf.inqAttName(ncid,varnum,j-1);
       attval=netcdf.getAtt(ncid,varnum,attname);
       attname(attname=='_')=[];
       eval(['ncstruct.' varnames{i} '.attributes.' attname ' =attval;'])
   end
   
end

% Get global attributes
k=0;
while 1    
    try
        gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),k);
        gattval=netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
        eval(['ncstruct.global_attributes.' gattname '=gattval;'])
        k=k+1;
        
    catch 
        break
    end
    
end

%
netcdf.close(ncid)