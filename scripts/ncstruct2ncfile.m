function varargout=ncstruct2ncfile(ncstruct,ncfile)
% ncstruct2ncfile(ncstruct,ncfile)

dim_names=fieldnames(ncstruct.dims);

ncid=netcdf.create(ncfile,'CLOBBER');
ndims=length(dim_names);

%Define dimensions
for i =1:ndims;
    dimids(i)=netcdf.defDim(ncid,dim_names{i},eval(['ncstruct.dims.' dim_names{i} ';']));
    
end

%%
% Define all variables
fnames=fieldnames(ncstruct);
for i=2:length(fnames)-1;
    clear dimids
    
    % get correct dimension number
    %disp(fnames{i})
    if isfield(eval(['ncstruct.' fnames{i}]),'dim_names')
        for j=1:length(eval(['ncstruct.' fnames{i} '.dim_names;']))        
            %disp(eval(['ncstruct.' fnames{i} '.dim_names{j}']))
             eval(['dimids(j)=netcdf.inqDimID(ncid,ncstruct.' fnames{i} '.dim_names{j});'])        
        end
    end
    
    % Create
    if exist('dimids')
        netcdf.defVar(ncid,fnames{i},'double',dimids);
        varid=netcdf.inqVarID(ncid,fnames{i});
    else
        netcdf.defVar(ncid,fnames{i},'double',[]);
        varid=netcdf.inqVarID(ncid,fnames{i});
        
    end
    if isfield(eval(['ncstruct.' fnames{i}]),'attributes')        
        attnames=fieldnames(eval(['ncstruct.' fnames{i} '.attributes']));
        for j=1:length(attnames);
            netcdf.putAtt(ncid,varid,attnames{j},eval(['ncstruct.' fnames{i} '.attributes.' attnames{j}]))
        end
    end
    
end
% global attributes
if(isfield(ncstruct.global_attributes,'history'))
     ncstruct.global_attributes.original_history=ncstruct.global_attributes.history;
else
    ncstruct.global_attributes.original_history='';
end
    
ncstruct.global_attributes.history=[ncstruct.global_attributes.original_history  char(10) ...
    'NetCDF4 file created by matlab ' date ...
    ' from script: ' char(10) ...
    '     ' mfilename('fullpath') char(10) ...
    'by ' getenv('USER') ];

if isfield(ncstruct,'global_attributes')
    global_atts=fieldnames(ncstruct.global_attributes);    
    for j=1:length(global_atts);
        netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),global_atts{j},eval(['ncstruct.global_attributes.' global_atts{j}]));
    end
end


% close netcdf file
netcdf.close(ncid)

% reopen to write
ncid=netcdf.open(ncfile,'WRITE');
for i=2:length(fnames)-1;
    varid=netcdf.inqVarID(ncid,fnames{i});
    if isfield(eval(['ncstruct.' fnames{i}]),'data')
%     disp(fnames{i})
        eval(['netcdf.putVar(ncid,varid,ncstruct.' fnames{i} '.data);'])
    end
end

%%
netcdf.close(ncid)

if nargout==1
    varargout={ncid};
end