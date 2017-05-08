function setp
%Function to set local paths and variable names. Should be called at the
%initial part of every script. It will (eventually) detect what machine
%things are running on, and set paths/environmental variable names
%accordingly.

[~,host]=system('hostname');
host=deblank(host);

switch host
  case 'Your Machine'
      % edit area here to set parameters for your machine
  otherwise
        % Setup all relevant paths and variable names that may change when        
        disp(['Running as generic'])
        scratchDir='../scratch/';
end
        
save sessionParams scratchDir
