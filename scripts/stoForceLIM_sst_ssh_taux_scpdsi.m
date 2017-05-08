disp('Stochastic forcing part (requires Q and B)')
clear
close all
setp
load sessionParams
%% --------------------------------------------------------------------------------

dataDir='../data/';
nr=10;
nYears=50;
nYearsExtra=1;
nPar = 24; % this will set the number of workers in the parfor loop, if you
            % are setting up your experiments to run in parallel
            % (recommended if possible). However, it isn't required.
limParamFile='sst_ssh_taux_historical_v20160511_195801-200012.Xeofs.TrPac.22pdsiEigs.Norm10000.limParams.mat';
dateTag=datestr(datenum(now),'yyyymmddHHMM');
disp(dateTag)

% you could modify this further to specify details of your results dir.
% note that by default a new folder will be created for EACH experiment...
resultsDir=[scratchDir '/limOut_' dateTag '/'];
if ~exist(resultsDir);
    eval(['!mkdir -p ' resultsDir]);
end

save lastRun dateTag resultsDir
%% --------------------------------------------------------------------------------
% General
load(limParamFile);

nt=size(X,1);
ns=size(X,2);

nDaysInMonth=30;
nHrsInDay=24;
nMonthsInYear=12;
nHrsInRn=3;
deltaT=nHrsInRn/(nHrsInDay*nDaysInMonth);  %6hrly data = 6/(24*30)=1/120
ntRn=(nDaysInMonth*nYears*(nHrsInDay/nHrsInRn)*nMonthsInYear);
ntRnExtra=(nDaysInMonth*nYearsExtra*(nHrsInDay/nHrsInRn)*nMonthsInYear);
nMoExtra=nYearsExtra*12;
% sampling is at Nhr hourly, so there are 120 time chunks per month:
moLen=(nDaysInMonth*(nHrsInDay/nHrsInRn));
nMo=ntRn/moLen;
time=(1:nMo)';

if nYears>1000;
    nYrDig=length(num2str(nYears));
else
    nYrDig=4;
end

[~,hostname]=system('hostname');
metaDescr=['Parameters for LIM are from:' limParamFile  '.' char(10) ...
          'NetCDF4 file created by matlab on ' date char(10) ...
          'from script: ' char(10) ...
          '     ' mfilename('fullpath') char(10) ...
          'by ' getenv('USER') char(10) ...
          'using ' hostname];
%% ------------------------ X1 ------------------------
eofStruct1=nc2struct([eofDir eofFile1]);
oFileTemplate1=strrep([resultsDir inFile1],'.nc', '.Rn_%s.nc');
[varname,realm,modid,expid,runid,yrStart,moStart,yrEnd,moEnd]=filename2fileinfo(inFile1);
oFileTemplate1=strrep(oFileTemplate1,[ind2str(yrStart,nYrDig) ind2str(moStart,2)],[ind2str(1,nYrDig) ind2str(1,2)]);
oFileTemplate1=strrep(oFileTemplate1,[ind2str(yrEnd,nYrDig) ind2str(moEnd,2)],[ind2str(nYears,nYrDig) ind2str(nMonthsInYear,2)]);
oFileTemplate1=strrep(oFileTemplate1,expid,['limCntrl' dateTag ]);

history1=['From ' inFile1 char(10) ...
          ' using eofs from ' eofFile1 char(10) ...
          ' neig=' num2str(neig1) '.' char(10) ...
          metaDescr];

%% ------------------------ X2 ------------------------
eofStruct2=nc2struct([eofDir eofFile2]);
oFileTemplate2=strrep([resultsDir inFile2],'.nc', '.Rn_%s.nc');
[varname,realm,modid,expid,runid,yrStart,moStart,yrEnd,moEnd]=filename2fileinfo(inFile2);
oFileTemplate2=strrep(oFileTemplate2,[ind2str(yrStart,nYrDig) ind2str(moStart,2)],[ind2str(1,nYrDig) ind2str(1,2)]);
oFileTemplate2=strrep(oFileTemplate2,[ind2str(yrEnd,nYrDig) ind2str(moEnd,2)],[ind2str(nYears,nYrDig) ind2str(nMonthsInYear,2)]);
oFileTemplate2=strrep(oFileTemplate2,expid,['limCntrl' dateTag ]);

history2=['From ' inFile2 char(10) ...
          ' using eofs from ' eofFile2 char(10) ...
          ' neig=' num2str(neig2) '.' char(10) ...
          metaDescr];


%% ------------------------ X3 ------------------------
eofStruct3=nc2struct([eofDir eofFile3]);
oFileTemplate3=strrep([resultsDir inFile3],'.nc', '.Rn_%s.nc');
[varname,realm,modid,expid,runid,yrStart,moStart,yrEnd,moEnd]=filename2fileinfo(inFile3);
oFileTemplate3=strrep(oFileTemplate3,[ind2str(yrStart,nYrDig) ind2str(moStart,2)],[ind2str(1,nYrDig) ind2str(1,2)]);
oFileTemplate3=strrep(oFileTemplate3,[ind2str(yrEnd,nYrDig) ind2str(moEnd,2)],[ind2str(nYears,nYrDig) ind2str(nMonthsInYear,2)]);
oFileTemplate3=strrep(oFileTemplate3,expid,['limCntrl' dateTag ]);

history3=['From ' inFile3 char(10) ...
          ' using eofs from ' eofFile3 char(10) ...
          ' neig=' num2str(neig3) '.' char(10) ...
          metaDescr];

%% ------------------------ X4 ------------------------
eofStruct4=nc2struct([eofDir eofFile4]);
oFileTemplate4=strrep([resultsDir inFile4],'.nc', '.Rn_%s.nc');
[varname,realm,modid,expid,runid,yrStart,moStart,yrEnd,moEnd]=filename2fileinfo(inFile4);
oFileTemplate4=strrep(oFileTemplate4,[ind2str(yrStart,nYrDig) ind2str(moStart,2)],[ind2str(1,nYrDig) ind2str(1,2)]);
oFileTemplate4=strrep(oFileTemplate4,[ind2str(yrEnd,nYrDig) ind2str(moEnd,2)],[ind2str(nYears,nYrDig) ind2str(nMonthsInYear,2)]);
oFileTemplate4=strrep(oFileTemplate4,expid,['limCntrl' datestr(datenum(now),'yyyymmddHHMM') ]);

history4=['From ' inFile4 char(10) ...
          ' using eofs from ' eofFile4 char(10) ...
          ' neig=' num2str(neig4) '.' char(10) ...
          metaDescr];
      
%% rescale "forcing functions"
nQeigs=neig1+neig2+neig3+neig4;
clear Qscld
for i =1:nQeigs
    Qscld(:,i)=Qeofs(:,i).*sqrt(Qv(i,i));
end 

%Subspace Indices
x1subq=(1:neig1);
x2subq=(1+neig1:neig1+neig2);
x3subq=(1+neig1+neig2:neig1+neig2+neig3);
x4subq=(1+neig1+neig2+neig3:neig1+neig2+neig3+neig4);

%%
p = gcp('nocreate'); % If no pool, do not create new one.
if ~isempty(p)
    delete(gcp)
end

%Uncomment these lines and comment line 132 to use parfor.
%parpool(nPar) 
%parfor n =1:nr;

for n =1:nr;
    
    %randomize start mo
    Xinit=0.0*X(randperm(nt,1),:);
    
    % Generate stochastically forced output:
    Xrand=stoForceFn(Xinit,B,Qscld,nQeigs,nMo,deltaT,moLen,nMoExtra);    
        
    % now split up into section (e.g., x1 | x2)
    X1rand=X1norm*(Xrand(x1subq,:))';
    X2rand=X2norm*(Xrand(x2subq,:))';
    X3rand=X3norm*(Xrand(x3subq,:))';    
    X4rand=X4norm*(Xrand(x4subq,:))';    
    
    %X1: project back onto original field:
    X1RandMoq=X1rand*eofStruct1.eofs.data';
    X1RandMo=nan(nlon1*nlat1,nMo);
    X1RandMo(q1,:)=X1RandMoq';
    X1RandMo3D=reshape(X1RandMo,nlon1,nlat1,nMo);    
    oFile1=strrep(oFileTemplate1,'%s',ind2str(n,4));
    saveLIMfn(oFile1,X1RandMo3D,lon1,lat1,time,history1)
    
    %X2: project back onto original field:
    X2RandMoq=X2rand*eofStruct2.eofs.data';
    X2RandMo=nan(nlon2*nlat2,nMo);
    X2RandMo(q2,:)=X2RandMoq';
    X2RandMo3D=reshape(X2RandMo,nlon2,nlat2,nMo);    
    oFile2=strrep(oFileTemplate2,'%s',ind2str(n,4));
    saveLIMfn(oFile2,X2RandMo3D,lon2,lat2,time,history2)
    
    %X3: project back onto original field:
    X3RandMoq=X3rand*eofStruct3.eofs.data';
    X3RandMo=nan(nlon3*nlat3,nMo);
    X3RandMo(q3,:)=X3RandMoq';
    X3RandMo3D=reshape(X3RandMo,nlon3,nlat3,nMo);    
    oFile3=strrep(oFileTemplate3,'%s',ind2str(n,4));
    saveLIMfn(oFile3,X3RandMo3D,lon3,lat3,time,history3)
    
    %X4: project back onto original field:
    X4RandMoq=X4rand*eofStruct4.eofs.data';
    X4RandMo=nan(nlon4*nlat4,nMo);
    X4RandMo(q4,:)=X4RandMoq';
    X4RandMo3D=reshape(X4RandMo,nlon4,nlat4,nMo);    
    oFile4=strrep(oFileTemplate4,'%s',ind2str(n,4));
    saveLIMfn(oFile4,X4RandMo3D,lon4,lat4,time,history4)

    
    %% sanity check:
    NN34(:,n)=X3D_to_nino34(X1RandMo3D,lon1,lat1);

end
