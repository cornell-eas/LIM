function XfiltStruct=doEOF_filter_wrap(Xresh,Xresh_smoo_q_anom,Xresh_smoo,X3D,q,tq_smoo,time_smoo,lon,lat,neig,nlon,nlat,ntsmoo,smoowin)
% XfiltStruct=doEOF_filter_wrap(Xresh_smoo_q_anom,Xresh_smoo,X3D,q,tq_smoo,time_smoo,lon,lat,neig,nlon,nlat,ntsmoo,smoowin)
    
    %SVD
    C_raw=cov(Xresh_smoo_q_anom);
    [U,S]=svds(C_raw,neig);
    
    %PCs:
    A=Xresh_smoo_q_anom*U;
    Z=A*U';
    Znan=nan(size(Xresh_smoo));
    Znan(:,q)=Z;
    Z3D=reshape(Znan',nlon,nlat,ntsmoo);
    emtx=sqrt(sum((rm_mtx_mean3D(X3D(:,:,tq_smoo))-rm_mtx_mean3D(Z3D)).^2,3)./ntsmoo);    
    
    corrXZ=nan(nlon*nlat,1);
    for i =1:length(q);
        corrXZ(q(i))=nancorr(Xresh(tq_smoo,q(i)),Znan(:,q(i)));
    end
    corr2D=reshape(corrXZ,nlon,nlat);    
        
    % set up dims
    XfiltStruct.dims.eig=neig;
    XfiltStruct.dims.time=ntsmoo;
    XfiltStruct.dims.lon=nlon;
    XfiltStruct.dims.lat=nlat;
    XfiltStruct.dims.q=length(q);
    XfiltStruct.dims.lonlat=nlon*nlat;
    XfiltStruct.dims.s=1;
    
    %make sure coordinates of each dim are stored
    XfiltStruct.eigs.data=diag(S);
    XfiltStruct.eigs.dim_names=cellstr('eig');
    
    XfiltStruct.lon.data=lon; 
    XfiltStruct.lon.dim_names=cellstr('lon');
        
    XfiltStruct.lat.data=lat; 
    XfiltStruct.lat.dim_names=cellstr('lat');
        
    XfiltStruct.time.data=time_smoo(tq_smoo); 
    XfiltStruct.time.dim_names=cellstr('time');
        
    XfiltStruct.q.data=q; 
    XfiltStruct.q.dim_names=cellstr('q');
        
    XfiltStruct.lonlat.data=1:nlon*nlat;
    XfiltStruct.lonlat.dim_names=cellstr('lonlat');        
        
    % now add main variables
    XfiltStruct.Xresh_smoo_q_anom_filt.data=Z;
    XfiltStruct.Xresh_smoo_q_anom_filt.dim_names={'time','q'};
    
    XfiltStruct.Xresh_smoo_anom_filt.data=Znan;
    XfiltStruct.Xresh_smoo_anom_filt.dim_names={'time','lonlat'};
    
    XfiltStruct.X3D_smoo_anom_filt.data=Z3D;
    XfiltStruct.X3D_smoo_anom_filt.dim_names={'lon','lat','time'};
    
    XfiltStruct.smoo_filt_emtx.data=emtx;
    XfiltStruct.smoo_filt_emtx.dim_names={'lon','lat'};
    
    XfiltStruct.smoo_filt_corr.data=corr2D;
    XfiltStruct.smoo_filt_corr.dim_names={'lon','lat'};
    
    XfiltStruct.totvar_retained.data=sum(diag(S))./sum(diag(C_raw));
    XfiltStruct.totvar_retained.dim_names=cellstr('s');
    
    XfiltStruct.smoowin.data=smoowin;
    XfiltStruct.smoowin.dim_names={'s'};
    
    XfiltStruct.eofs.data=U;
    XfiltStruct.eofs.dim_names={'q','eig'};
    
    XfiltStruct.pcs.data=A;
    XfiltStruct.pcs.dim_names={'time','eig'};