clear
close all

load lastRun
expid=dateTag; % Modify to point to different experiments
tShift=17;
latAdj=1.25;
lonAdj=1.25;
load(['limDiagnosticslimCntrl' expid]);
paneq=(1:nr); % could be modifed to adjust the order of realizations shown in figures.
nrows=3;
ncols=4;
npanes=nrows*ncols;
figure(1)
[axbig,axother]=plotmatrix(randn(nrows,ncols),randn(nrows,nrows));
axpos=cell2mat(get(axother','pos'));
close 1

%%
% load NINO34.txt
tEdges=[1951 2000];
scpdsiOneRn=nc2struct('../data/scpdsi_Amon_Scheffield_historical_vCRU3p10pm_195801-200012.WNA.nc');
sst=nc2struct('../data/sst_Omon_Kaplan_historical_v2_195801-200012.TrPac.nc');
varname='pdsi_pm'; lonName='longitude'; latName='latitude'; timeName='time';
scpdsi_timeq=find(scpdsiOneRn.(timeName).data>=tEdges(1) & scpdsiOneRn.(timeName).data<=tEdges(2));
nn34Kap_ts=X3D_to_nino34(sst.ssta.data,sst.X.data,sst.Y.data);

nn34JFMKap=(nn34Kap_ts(1:12:end)+nn34Kap_ts(2:12:end)+nn34Kap_ts(3:12:end))./3;
scpdsiJJA=(scpdsiOneRn.pdsi_pm.data(:,:,6:12:end)+scpdsiOneRn.pdsi_pm.data(:,:,7:12:end)+scpdsiOneRn.pdsi_pm.data(:,:,8:12:end))./3;
corrMap_nn34_scpdsi_obs=corr3D(nn34JFMKap,scpdsiJJA);



%%
figure(1)
clf
m_proj('mercator','longitudes',minmax(lon4'),'latitudes',minmax(lat4'));
for i =1:min(npanes,nr);
    ax(i)=axes('pos',axpos(i,:));
    if i ==1
        m_pcolor(lon4,lat4,corrMap_nn34_scpdsi_obs');
        m_text(min(lon4)+.25,min(lat4)+1,'Obs')
    else
        m_pcolor(lon4,lat4,corrMapsJJA(:,:,paneq(i))')
        m_text(min(lon4)+.25,min(lat4)+1,num2str(paneq(i)))
    end
    shading flat
    caxis([-1 1])
    set(gca,'xtick',[],'ytick',[])
    
end
c=colorbar('horiz','position',[0.1339    0.0714    0.7714    0.0310]);
xlabel(c,'correlation');
load BlueDarkOrange18
colormap(BlueDarkOrange18)

tl=title(ax(2),'NINO34 (JFM) - PDSI (JJA) Correlations');
set(tl,'pos',[    0.1729    1.0106         0])

fig4doc('f4',['../figs/NN34Corrs_LIM_sst_ssh_taux_scpdsi'])
%%
oFileKap='../data/kaplan_nino34_185601-201512.nc';
oFileHad='../data/HadISST1_nino34_187001-201512.nc';
oFileERSST='../data/ERSSTv3b_nino34_185401-201512.nc';

% url='http://iridl.ldeo.columbia.edu/expert/SOURCES/.KAPLAN/.EXTENDED/.v2/.ssta/X/-170/-120/RANGEEDGES/Y/-5/5/RANGEEDGES/T/(Jan%201856)/(Dec%202015)/RANGE/%5BX/Y%5Daverage/data.cdf';
% ml_wget(oFile,url);
nn34Kap=nc2struct(oFileKap);
nn34ERSSTv3b=nc2struct(oFileERSST);
nn34Had=nc2struct(oFileHad);
%

nn34Kap_ts=nn34Kap.ssta.data;
nn34JFMKap=(nn34Kap_ts(1:12:end)+nn34Kap_ts(2:12:end)+nn34Kap_ts(3:12:end))./3;
nn34ObsPxx(:,1)=mtmspec(nn34JFMKap,nf,0);
%
nn34Had_ts=nn34Had.ssta.data;
nn34JFMHad=(nn34Had_ts(1:12:end)+nn34Had_ts(2:12:end)+nn34Had_ts(3:12:end))./3;
nn34ObsPxx(:,2)=mtmspec(nn34JFMHad,nf,0);
%
nn34ERSST_ts=nn34ERSSTv3b.anom.data(:);
nn34JFMERSST=(nn34ERSST_ts(1:12:end)+nn34ERSST_ts(2:12:end)+nn34ERSST_ts(3:12:end))./3;
nn34ObsPxx(:,3)=mtmspec(nn34JFMERSST,nf,0);

figure(2)
clf
UPxxMon=sort(allNNPxxMon ,2);
nn34ObsPxxMo(:,1)=mtmspec(nn34Kap.ssta.data,nf*12,0);
nn34ObsPxxMo(:,2)=mtmspec(nn34Had.ssta.data,nf*12,0);
nn34ObsPxxMo(:,3)=mtmspec(nn34ERSSTv3b.anom.data(:),nf*12,0);
nn34ObsPxxMo(fmo<1./nn34Kap.dims.T,:)=nan;

lineColorOrder=plasma(4);
clvq=round(nr.*[1-0.975 0.975]);
clvq(clvq==0)=1;% make sure to get rid of 0 indices if nr is too low.

hold on
for i =1:3
    loglog(fmo*12,nn34ObsPxxMo(:,i),'color',lineColorOrder(i,:))
end
lines2patch(fmo*12,UPxxMon(:,clvq),[.7 .7 .7]);
for i =1:3
    loglog(fmo*12,nn34ObsPxxMo(:,i),'color',lineColorOrder(i,:))
end
set(gca,'xlim',1./[500 0.2],'xscale','log','yscale','log')
plot(fmo*12,UPxxMon(:,clvq),'color','k');
box on
xlabel ('Frequency (years^{-1})')
ylabel ('Spectral Density (^oC/\Delta f)')
legend('Kaplan','HadISST','ERSSTv3b','location','Southwest')
title ('NINO3.4 Power Spectra')
%
fig4doc('f4.5','../figs/Pxx_LIM_sst_ssh_taux_scpdsi')

 