clear
close all
%% Modify this area to specify Y, tau, neigs
% general:
limParamFile='sst_ssh_taux_historical_v20160511_195801-200012.Xeofs.TrPac.22pdsiEigs.Norm10000.limParams.mat';
eofDir='../results/';
paramDir='../params/';
pauseOn=false;
doEofs=true;

% lag (tau) range
tau0=3;
tauRange=[3:15];

%% ------------------- define X1 ---------------------------------------
inDir1='../data/';
inFile1='sst_Omon_Kaplan_historical_v2_195801-200012.TrPac.nc';
varname1='ssta'; lonName='X'; latName='Y'; timeName='T';
neig1=17;
smoowin1=3;

%import data
dataStruct1=nc2struct([inDir1 inFile1]);
missingVal1=dataStruct1.(varname1).attributes.missingvalue; dataStruct1.(varname1).data(dataStruct1.(varname1).data==missingVal1)=nan;
X3D1=dataStruct1.(varname1).data; lon1=dataStruct1.(lonName).data; lat1=dataStruct1.(latName).data; time1=dataStruct1.(timeName).data;
nlon1=length(lon1); nlat1=length(lat1); ntraw1=length(time1);

% Smooth:
X1resh=reshape(X3D1,nlon1*nlat1,ntraw1)';
X1resh_smoo=smoothx(X1resh,smoowin1,'mean');
time1_smoo=smoothx(time1,smoowin1,'mean');
tq1_smoo=find(~isnan(time1_smoo));
nt1smoo=length(tq1_smoo);
X1resh_smoo=X1resh_smoo(tq1_smoo,:); %get rid of empty rows
q1=find(~all(isnan(X1resh_smoo)));
X1resh_smoo_q=X1resh_smoo(:,q1);
X1resh_smoo_q_anom=rm_mtx_mean(X1resh_smoo_q);

% do eof Filtering
eofFile1=strrep(inFile1,'.nc','.eofs.nc');
if doEofs
    XfiltStruct1=doEOF_filter_wrap(X1resh,X1resh_smoo_q_anom,X1resh_smoo,X3D1,q1,tq1_smoo,time1_smoo,lon1,lat1,neig1,nlon1,nlat1,nt1smoo,smoowin1);
    XfiltStruct1.global_attributes.history=['Created from ' inFile1];
    ncstruct2ncfile(XfiltStruct1,[eofDir eofFile1]);    
end

%% ------------------- define X2 ---------------------------------------
inDir2='../data/';
inFile2='ssh_Omon_CARTON-GIESE-SODA_historical_v2p0p2p4_195801-200012.TrPac.nc';
varname2='ssh'; lonName='lon'; latName='lat'; timeName='time';
neig2=7;
smoowin2=3;

%import data
dataStruct2=nc2struct([inDir2 inFile2]);
missingVal2=dataStruct2.(varname2).attributes.missingvalue; dataStruct2.(varname2).data(dataStruct2.(varname2).data==missingVal2)=nan;
X3D2=dataStruct2.(varname2).data; lon2=dataStruct2.(lonName).data; lat2=dataStruct2.(latName).data; time2=dataStruct2.(timeName).data;
nlon2=length(lon2); nlat2=length(lat2); ntraw2=length(time2);

% Smooth:
X2resh=reshape(X3D2,nlon2*nlat2,ntraw2)';
X2resh_smoo=smoothx(X2resh,smoowin2,'mean');
time2_smoo=smoothx(time2,smoowin2,'mean');
tq2_smoo=find(~isnan(time2_smoo));
nt2smoo=length(tq2_smoo);
X2resh_smoo=X2resh_smoo(tq2_smoo,:); %get rid of empty rows
q2=find(~all(isnan(X2resh_smoo)));
X2resh_smoo_q=X2resh_smoo(:,q2);
X2resh_smoo_q_anom=rm_mtx_mean(X2resh_smoo_q);

% do eof Filtering
eofFile2=strrep(inFile2,'.nc','.eofs.nc');
if doEofs
    XfiltStruct2=doEOF_filter_wrap(X2resh,X2resh_smoo_q_anom,X2resh_smoo,X3D2,q2,tq2_smoo,time2_smoo,lon2,lat2,neig2,nlon2,nlat2,nt2smoo,smoowin2);
    XfiltStruct2.global_attributes.history=['Created from ' inFile2];
    ncstruct2ncfile(XfiltStruct2,[eofDir eofFile2]);    
end
%% ------------------- define X3 ---------------------------------------
inDir3='../data/';
inFile3='taux_Omon_CARTON-GIESE-SODA_historical_v2p0p2p4_195801-200012.TrPac.nc';
varname3='taux'; lonName='lon'; latName='lat'; timeName='time';
neig3=3;
smoowin3=3;

%import data
dataStruct3=nc2struct([inDir3 inFile3]);
missingVal3=dataStruct3.(varname3).attributes.missingvalue; dataStruct3.(varname3).data(dataStruct3.(varname3).data==missingVal3)=nan;
X3D3=dataStruct3.(varname3).data; lon3=dataStruct3.(lonName).data; lat3=dataStruct3.(latName).data; time3=dataStruct3.(timeName).data;
nlon3=length(lon3); nlat3=length(lat3); ntraw3=length(time3);

% Smooth:
X3resh=reshape(X3D3,nlon3*nlat3,ntraw3)';
X3resh_smoo=smoothx(X3resh,smoowin3,'mean');
time3_smoo=smoothx(time3,smoowin3,'mean');
tq3_smoo=find(~isnan(time3_smoo));
nt3smoo=length(tq3_smoo);
X3resh_smoo=X3resh_smoo(tq3_smoo,:); %get rid of empty rows
q3=find(~all(isnan(X3resh_smoo)));
X3resh_smoo_q=X3resh_smoo(:,q3);
X3resh_smoo_q_anom=rm_mtx_mean(X3resh_smoo_q);

% do eof Filtering
eofFile3=strrep(inFile3,'.nc','.eofs.nc');
if doEofs
    XfiltStruct3=doEOF_filter_wrap(X3resh,X3resh_smoo_q_anom,X3resh_smoo,X3D3,q3,tq3_smoo,time3_smoo,lon3,lat3,neig3,nlon3,nlat3,nt3smoo,smoowin3);
    XfiltStruct3.global_attributes.history=['Created from ' inFile3];
    ncstruct2ncfile(XfiltStruct3,[eofDir eofFile3]);    
end

%% ------------------- define X4 ---------------------------------------
inDir4='../data/';
inFile4='scpdsi_Amon_Scheffield_historical_vCRU3p10pm_195801-200012.WNA.nc';
varname4='pdsi_pm'; lonName='longitude'; latName='latitude'; timeName='time';
neig4=22;
smoowin4=3;

%import data
dataStruct4=nc2struct([inDir4 inFile4]);
missingVal4=-999000000; dataStruct4.(varname4).data(dataStruct4.(varname4).data==missingVal4)=nan;
X3D4=dataStruct4.(varname4).data; lon4=dataStruct4.(lonName).data; lat4=dataStruct4.(latName).data; time4=dataStruct4.(timeName).data;
nlon4=length(lon4); nlat4=length(lat4); ntraw4=length(time4);

% Smooth:
X4resh=reshape(X3D4,nlon4*nlat4,ntraw4)';
X4resh_smoo=smoothx(X4resh,smoowin4,'mean');
time4_smoo=smoothx(time4,smoowin4,'mean');
tq4_smoo=find(~isnan(time4_smoo));
nt4smoo=length(tq4_smoo);
X4resh_smoo=X4resh_smoo(tq4_smoo,:); %get rid of empty rows
q4=find(~all(isnan(X4resh_smoo)));
X4resh_smoo_q=X4resh_smoo(:,q4);
X4resh_smoo_q_anom=rm_mtx_mean(X4resh_smoo_q);

% do eof Filtering
eofFile4=strrep(inFile4,'.nc','.eofs.nc');
if doEofs
    XfiltStruct4=doEOF_filter_wrap(X4resh,X4resh_smoo_q_anom,X4resh_smoo,X3D4,q4,tq4_smoo,time4_smoo,lon4,lat4,neig4,nlon4,nlat4,nt4smoo,smoowin4);
    XfiltStruct4.global_attributes.history=['Created from ' inFile4];
    ncstruct2ncfile(XfiltStruct4,[eofDir eofFile4]);    
end

%% we will now assign output from the filtering to X:
disp('Testing legitimacy of [Btau0]...')
X1norm=sqrt(sum(diag(cov(XfiltStruct1.pcs.data))));
X1=XfiltStruct1.pcs.data;
X1=X1./X1norm;

X2norm=sqrt(sum(diag(cov(XfiltStruct2.pcs.data))));
X2=XfiltStruct2.pcs.data;
X2=X2./X2norm;

X3norm=sqrt(sum(diag(cov(XfiltStruct3.pcs.data))));
X3=XfiltStruct3.pcs.data./X3norm;

X4norm=10000*sqrt(sum(diag(cov(XfiltStruct4.pcs.data))));
X4=XfiltStruct4.pcs.data./X4norm;

X=[X1 X2 X3 X4];
Ctau0=lagCov(X,X,tau0);
Co=cov(X);

% Calculate B (PS95, eq. [4])
Btau0=(1./tau0)*logm(Ctau0*pinv(Co));%
Btau0_eigs=real(eigs(Btau0,10));
if any(Btau0_eigs>0)
     error('Failed: Eigenvalues of B have real positive parts')      
end

disp('Passed: Eigenvalues of B do not have real positive parts')

%% 3) Is [Q] (determined from [B][C0]+[C0][B]'+[Q]=0) positive definite?
disp('3) Is [Q] (determined from [B][C0]+[C0][B]''+[Q]=0) positive definite?')
B=Btau0;
tau=tau0;
Ctau=Ctau0;
B_eigs=Btau0_eigs;
Q=-(B*Co+Co*B');
[Qeofs,Qv]=svd(Q);
if(any(diag(Qv)<0)) 
    error('Some eigenvalues of Q <0. These should be eliminated.');    
end
Qeigs=diag(Qv);
save(limParamFile,'tau','X','X1','X2','X3','X4','Ctau','Co','B','B_eigs','Q','Qeofs','Qeigs','Qv',...
     'neig*','q*','lon*','lat*','nlon*','nlat*','inFile*','X*norm','eofFile*','eofDir');

%% Compare filtered data to original
% requires m_map
try 
    figure(1);
    clf;
    subplot(211)
        NN34=X3D_to_nino34(dataStruct1.ssta.data,dataStruct1.X.data,dataStruct1.Y.data);
        NN34JJA=(NN34(1:12:end)+NN34(2:12:end)+NN34(3:12:end))./3;
        scpdsiJJA=(dataStruct4.pdsi_pm.data(:,:,6:12:end)+dataStruct4.pdsi_pm.data(:,:,7:12:end)+dataStruct4.pdsi_pm.data(:,:,8:12:end))./3;
        corrMap0=corr3D(NN34JJA,scpdsiJJA);
        m_pcolor(XfiltStruct4.lon.data,XfiltStruct4.lat.data,corrMap0');
        shading flat;
        colormap(BlueDarkOrange18);
        caxis([-1 1]);
        colorbar;    

    subplot(212)
        ssteofs=XfiltStruct1;
        NN34smoofilt=X3D_to_nino34(ssteofs.X3D_smoo_anom_filt.data,ssteofs.lon.data,ssteofs.lat.data);
        NN34smoofiltJJA=(NN34smoofilt(1:12:end)+NN34smoofilt(2:12:end)+NN34smoofilt(3:12:end))./3;
        scpdsiSmooFiltJJA=(XfiltStruct4.X3D_smoo_anom_filt.data(:,:,1:12:end)+XfiltStruct4.X3D_smoo_anom_filt.data(:,:,2:12:end)+XfiltStruct4.X3D_smoo_anom_filt.data(:,:,3:12:end))./3;
        corrMap=corr3D(NN34smoofiltJJA,scpdsiSmooFiltJJA);
        m_pcolor(XfiltStruct4.lon.data,XfiltStruct4.lat.data,corrMap');
        shading flat;
        colormap(BlueDarkOrange18);
        caxis([-1 1]);
        colorbar;
catch
    disp('Failed plotting results. Try downloading and using m_map, or adding it to your path.')
end

disp(['Results saved in "' limParamFile '"']);
disp(['EOFs saved in "' eofDir '"'])