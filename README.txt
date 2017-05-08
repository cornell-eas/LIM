Data are stored in LIM/data/
     - retreived using get_T_H_Taux_data.m   
Scripts are in LIM/scripts/


STEP 0: setp.m is a function called by many scripts to define the
     	environmental parameters like the scratch directory. This
 	might need modification if you decide to run the scripts 
	different machines or new machines at some point.

STEP 1: create a file like "LIM_sst_ssh_taux_scpdsi.m" to define X1,
        X2, X3, X4, etc... with neigs, filtering, etc...
	this requires data to be in ../data/, and also the functions:
	    corr3D
        nancorr
        nc2struct
        ncgetvar_names
        ncstruct2ncfile
        rm_mtx_mean
        rm_mtx_mean3D
        setp
        smoothx
        doEOF_filter_wrap
	    lagCov

    And optionally (for plotting):
        lon180_360
        X3D_tonino34.m

STEP 2: Create a file like "stoForceLIM_sst_ssh_taux_scpdsi.m" to
        do the stochastic forcing part (SLOW, runs in parallel by default).
	This calls stoForceFn.m as stoForceFn(Xinit,B,Qscld,nQeigs,nMo,deltaT,moLen,nMoExtra).
	Also handles splitting out [X1| X2| X3| X4] into individual variables.

STEP 3: Create a file like "stoForceLIM_sst_ssh_taux_scpdsi.m" as a driver
        script for your LIM. This will require:
            
            stoForceFn (a function that handles the heavy lifting and makes 
                    parallel processing possible).
       
        Edit this to modify:
            - nr (number of stochastic realizations)
            - nYears (number of years per simulation)
            - resultsDir (optional)

        Run your StoForceLIM driver script:
            -Requires user to specify limParamFile
            -Will store all output in the "resulsDir."
            -Will also create a matlab file called "lastRun" which will store only the "dateTag"
             (this can be useful later b/c each dateTag is unique down to the minute)

        IMPORTANT NOTES: 
            1. BE CAREFUL - This script can produce a prodigious volume of 
                data. You can easily fill up a hard drive by setting nYears
                and nr to large numbers.            
            2. It will also create a new directory each time it is run, unless
            you specify otherwise.
            3. By default, it creates netCDF files from each of the variables
            used in the LIM. This could be modifed in the driver script to
            only save PC time series, then with the EOFs saved in ../results,
            the user could re-project each realization onto its EOF loadings.
            Such an approach would save considerable storage space.
                     
Optional Diagnostics (ENSO specific):

STEP 4: Run mkNINO34pxx_and_corrs
     	- you can specify the expermental ID using the variable "expid"
        - or you can use the "last run" as the default

STEP 5: Run mkLIMDiagPlots.m
