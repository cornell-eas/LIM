function varnames=ncgetvar_names(filename);
%varnames=ncgetvar_names(filename);

a=netcdf.open(filename,0);
varindx=netcdf.inqVarIDs(a);
nvars=length(varindx);
for i =1:nvars
    varnames{i,1}=netcdf.inqVar(a,varindx(i));
end
netcdf.close(a);