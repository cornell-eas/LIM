function saveLIMfn(oFile,XrandMo3D,lon,lat,time,varargin)

nlon=length(lon);
nlat=length(lat);
nMo=length(time);

limOut.dims.lon=nlon;
limOut.dims.lat=nlat;
limOut.dims.time=nMo;

limOut.lon.data=lon;
limOut.lon.dim_names=cellstr('lon');

limOut.lat.data=lat;
limOut.lat.dim_names=cellstr('lat');

limOut.time.data=time;
limOut.time.dim_names=cellstr('time');

limOut.mvrn.data=nan(nlon,nlat,nMo);
limOut.mvrn.dim_names={'lon','lat','time'};

if ~isempty(varargin)
    limOut.global_attributes.history=varargin{:};
else
    limOut.global_attributes.history='';
end

limOut.mvrn.data(:,:,:)=XrandMo3D;

ncstruct2ncfile(limOut,oFile)