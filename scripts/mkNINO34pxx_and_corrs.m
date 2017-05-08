clear
close all
setp
load sessionParams

%--- HEADER

load lastRun
expid=dateTag;
%expid='201605132235';
inDir=resultsDir; % this could be modified so that this script will 
                  %look at whatever results you point it to...

%------
swLonEdges=lon180_360([-115 -105]);
swLatEdges=[32 38];


sstFlist=dir([inDir 'sst_*' expid '*.nc']);
pdsiFlist=dir([inDir 'scpdsi_*' expid '*.nc']);

[varname,realm,modid,expid,runid,yrStart,moStart,yrEnd,moEnd]=filename2fileinfo(sstFlist(1).name);

time=((yrStart+(moStart-0.5)/12):1/12:(yrEnd+(moEnd-0.5)/12))';

lon1Struct=nc2struct([inDir sstFlist(1).name],'lon');
lon1=lon1Struct.lon.data;
lat1Struct=nc2struct([inDir sstFlist(1).name],'lat');
lat1=lat1Struct.lat.data;

lon2Struct=nc2struct([inDir pdsiFlist(1).name],'lon');
lon2=lon2Struct.lon.data;
lat2Struct=nc2struct([inDir pdsiFlist(1).name],'lat');
lat2=lat2Struct.lat.data;

nt=length(time);
nr=length(sstFlist);
nf=1000;

nlon1=length(lon1);
nlat1=length(lat1);

nlon2=length(lon2);
nlat2=length(lat2);

allNN=nan(nt,nr);
allNNJFM=nan(nt/12,nr);
allNNannual=nan(nt/12,nr);
allNNPxxJFM=nan(nf/2+1,nr);
allNNPxxANN=nan(nf/2+1,nr);
AllNNPxxMon=nan((nf+12)/2+1,nr);

swpdsi=nan(nt,nr);
swpdsiJJA=nan(nt/12,nr);
swpdsiJJAsmoo=nan(nt/12,nr);

nYr=nt/12;
dai1JJA=nan(nYr,nr);
dai2JJA=nan(nYr,nr);
dai3JJA=nan(nYr,nr);

corrMapsJFM=nan(nlon2,nlat2,nr);
corrMapsJJA=nan(nlon2,nlat2,nr);
corrMapsANN=nan(nlon2,nlat2,nr);

dai_norm_JJA=nan(nYr,nr);
dai_norm_JJA_pred=nan(nYr,nr);
dai_norm_max=nan(1,nr);
dai_norm_pos=nan(1,nr);
sst_dai_max=nan(nlon1,nlat1,nr);
scpdsiJJA_dai_max=nan(nlon2,nlat2,nr);

sst_swpdsiMegadrought=nan(nlon1,nlat1,nr);
scpdsiJJA_swpdsiMegadrought=nan(nlon2,nlat2,nr);

mvrnTimeEdges=[nYr-99 nYr];
scpdsi=nc2struct([inDir pdsiFlist(1).name]);    
nPts=sum(sum(~isnan(scpdsi.mvrn.data(:,:,1))));

[~,f]=mtmspec(nan(nYr,1),nf,0);
[~,fmo]=mtmspec(nan(nYr,1),nf*12,0);

%% set up regression of SST onto scpdsi
scpdsi=nc2struct('../data/scpdsi_Amon_Scheffield_historical_vCRU3p10pm_195801-200012.WNA.nc');
sst=nc2struct('../data/sst_Omon_Kaplan_historical_v2_195801-200012.TrPac.nc');
load sst_ssh_taux_historical_v20160511_195801-200012.Xeofs.TrPac.22pdsiEigs.Norm10000.limParams.mat
pdsiEOFs=nc2struct('../results/scpdsi_Amon_Scheffield_historical_vCRU3p10pm_195801-200012.WNA.eofs.nc');
sstEOFs=nc2struct('../results/sst_Omon_Kaplan_historical_v2_195801-200012.TrPac.eofs.nc');

time=pdsiEOFs.time.data;
nePred4=10;
X4=X4norm*X4(:,1:nePred4);
X1=X1norm*X1;
m=(pinv(X1)*X4);
X4linpred=X1*m;
pdsi_pred_q=X4*pdsiEOFs.eofs.data(:,1:nePred4)';
pdsi_pred=nan(length(time),nlon4*nlat4);
pdsi_pred(:,pdsiEOFs.q.data)=pdsi_pred_q;
pdsi_pred3D=reshape(pdsi_pred',nlon4,nlat4,length(time));

%sanit Check
corrMap_pdsiPred_with_Raw=nan(nlon4,nlat4);
for i =1:nlon4;
    for j=1:nlat4;
        x=squeeze(scpdsi.pdsi_pm.data(i,j,2:end-2));
        y=squeeze(pdsi_pred3D(i,j,:));
        corrMap_pdsiPred_with_Raw(i,j)=corr(x,y);
    end
end


%%
%nr =100
%warning('nr =100')
%parfor i =1:nr
for i =1:nr
    sst=nc2struct([inDir sstFlist(i).name]);    
    scpdsi=nc2struct([inDir pdsiFlist(i).name]);    
    
    %% time series stuff
    % NINO3.4
    nino34=X3D_to_nino34(sst.mvrn.data,sst.lon.data,sst.lat.data);    
    nino34JFM=(nino34(1:12:end)+nino34(2:12:end)+nino34(3:12:end))./3;
    nino34ANN=mean(reshape(nino34,12,[]))';

    [nn34PxxJFM,f]=mtmspec(nino34JFM,nf,0);
    [nn34PxxANN,f]=mtmspec(nino34ANN,nf,0);
    [nn34PxxMon,fmo]=mtmspec(nino34,nf*12,0);
    

    allNN(:,i)=nino34;
    allNNJFM(:,i)=nino34JFM;
    allNNannual(:,i)=nino34ANN;
    allNNPxxJFM(:,i)=nn34PxxJFM;
    allNNPxxANN(:,i)=nn34PxxANN;
    allNNPxxMon(:,i)=nn34PxxMon;

    %% SW PDSI
    lonq=find(scpdsi.lon.data>=swLonEdges(1) & scpdsi.lon.data<=swLonEdges(2));
    latq=find(scpdsi.lat.data>=swLatEdges(1) & scpdsi.lat.data<=swLatEdges(2));
    tmp=squeeze(nanmean(nanmean(scpdsi.mvrn.data(lonq,latq,:))));
    swpdsi(:,i)=tmp;
    swpdsiJJA(:,i)=(tmp(6:12:end)+tmp(7:12:end)+tmp(8:12:end))./3;
    swpdsiJJAsmoo(:,i)=smoothx(mtx_std(swpdsiJJA(:,i)),35,'mean');
    [~,posMegadrought]=min(swpdsiJJAsmoo<-0.5);

    q1swMegadrought=posMegadrought-17:posMegadrought+17;
    q1swMegadrought(q1swMegadrought<1)=[];
    q1swMegadrought(q1swMegadrought>nYr)=[];    

    % correlation part
    pdsiJFM=(scpdsi.mvrn.data(:,:,1:12:end)+ ...
             scpdsi.mvrn.data(:,:,2:12:end)+ ...
             scpdsi.mvrn.data(:,:,3:12:end))./3;

    pdsiJJA=(scpdsi.mvrn.data(:,:,6:12:end)+ ...
             scpdsi.mvrn.data(:,:,7:12:end)+ ...
             scpdsi.mvrn.data(:,:,8:12:end))./3;

    corr2D_JFM=corr3D(nino34JFM,pdsiJFM);
    corr2D_JJA=corr3D(nino34JFM,pdsiJJA);
    corr2D_ANN=corr3D(nino34JFM,pdsiJJA);
    
    corrMapsJFM(:,:,i)=corr2D_JFM;
    corrMapsJJA(:,:,i)=corr2D_JJA;
    corrMapsANN(:,:,i)=corr2D_ANN;

    dai1JJA(:,i)=squeeze(sum(sum(pdsiJJA<-1)))./nPts;
    dai2JJA(:,i)=squeeze(sum(sum(pdsiJJA<-2)))./nPts;
    dai3JJA(:,i)=squeeze(sum(sum(pdsiJJA<-3)))./nPts;

    [pdsiJJA_norm,refMn2D,refStd2D]=modZscore3D(pdsiJJA,(1:nYr)',mvrnTimeEdges);
    pdsiJJA_norm_smoo=smoothX3D(pdsiJJA_norm,35,'mean');
    
    dai_norm_JJA(:,i)=squeeze(sum(sum(pdsiJJA_norm_smoo<-0.5))./nPts);
    [dai_norm_max(1,i),dai_norm_pos(1,i)]=max(dai_norm_JJA(:,i));

    sstJJA=(sst.mvrn.data(:,:,1:12:end)+sst.mvrn.data(:,:,2:12:end)+sst.mvrn.data(:,:,3:12:end))./3;
    dai_q=dai_norm_pos(1,i)-17:dai_norm_pos(1,i)+17;
    dai_q(dai_q<1)=[];
    dai_q(dai_q>nYr)=[];

    sst_dai_max(:,:,i)=mean(sstJJA(:,:,dai_q),3);
    scpdsiJJA_dai_max(:,:,i)=mean(pdsiJJA(:,:,dai_q),3);

    sst_swpdsiMegadrought(:,:,i)=mean(sstJJA(:,:,q1swMegadrought),3);
    scpdsiJJA_swpdsiMegadrought(:,:,i)=mean(pdsiJJA(:,:,q1swMegadrought),3);

    % now do the same, but for regression:
    sst_mvrn_flat=reshape(sst.mvrn.data,sst.dims.lon*sst.dims.lat,sst.dims.time)';
    sst_mvrn_flatq=sst_mvrn_flat(:,sstEOFs.q.data);
    X1_mvrn=sst_mvrn_flatq*sstEOFs.eofs.data;
    X4linpred_mvrn=X1_mvrn*m;
    pdsi_mvrn_pred_q=X4linpred_mvrn*pdsiEOFs.eofs.data(:,1:nePred4)';
    pdsi_mvrn_pred=nan(scpdsi.dims.time,nlon4*nlat4);
    pdsi_mvrn_pred(:,pdsiEOFs.q.data)=pdsi_mvrn_pred_q;
    pdsi_mvrn_pred3D=reshape(pdsi_mvrn_pred',nlon4,nlat4,scpdsi.dims.time);
    
    pdsi_mvrn_pred3D_JJA=(pdsi_mvrn_pred3D(:,:,6:12:end)+ ...
                          pdsi_mvrn_pred3D(:,:,7:12:end)+ ...
                          pdsi_mvrn_pred3D(:,:,8:12:end))./3;

    pdsi_mvrn_pred3D_JJA_norm=(pdsi_mvrn_pred3D_JJA-repmat(refMn2D,[1 1 nYr]))./repmat(refStd2D,[1 1 nYr]);
    pdsi_mvrn_pred3D_JJA_norm_smoo=smoothX3D(pdsi_mvrn_pred3D_JJA_norm,35,'mean');
    dai_norm_JJA_pred(:,i)=squeeze(sum(sum(pdsi_mvrn_pred3D_JJA_norm_smoo<-0.5))./nPts);


end

save(['limDiagnostics' expid],'corrMaps*','allNN*','lon1','lat1','nr','nf','f','dai*',...
     'dai_norm_max','scpdsiJJA_dai_max','dai_norm_pos','sst_dai_max','lon4','lat4','fmo',...
     'swLonEdges','swLatEdges','mvrnTimeEdges','swpdsi','swpdsiJJA','corrMap_pdsiPred_with_Raw','*swpdsiMegadrought',...
     'swpdsiJJAsmoo');