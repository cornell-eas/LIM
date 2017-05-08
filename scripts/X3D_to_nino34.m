function nino34=X3D_to_nino34(sst,lon,lat)
% nino34=X3D_to_nino34(sst,lon,lat)
lon=lon180_360(lon);
nino34lons=[190  240];
nino34lats=[-5 5];
qnn34lon= lon>nino34lons(1) & lon<=nino34lons(2);
qnn34lat= lat>nino34lats(1) & lat<=nino34lats(2);

sst=permute(sst,[find(size(sst)==length(lon)) find(size(sst)==length(lat)) 3]);
nino34=squeeze(mean(mean(sst(qnn34lon,qnn34lat,:))));
