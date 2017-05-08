function [Xsmooth,h] = smoothx(X,w,FilterType);
%Usage Xsmooth = smoothx(X,w,FilterType);
%
%Inputs:       
%X..............Vector or matrix whos columns are observations in time
%w..............Length of smoothing window (must be odd);
%FilterType.....Type of filter to be used current options (case sensitive)
%               Are: 'hamm', 'hann', or 'tria' for a hamming, hanning, or
%               triangular filter, respectively.
%
%Outputs
%Xsmooth........Smoothed version of X
%h..............Window used for smoothing
%
%Example:
%X = rand(10,2);
%[Xsmooth,h] = smoothx(X,3,'tria');
%
%Returns a smoothed version of X with NaNs on the ends
%and a 3x1 vector, h=
%                    .25
%                    .5
%                    .25

if strcmp(FilterType,'hamm');
    h = hamming(w)/sum(hamming(w));
elseif strcmp(FilterType,'hann');
    h = hanning(w)/sum(hanning(w));
elseif strcmp(FilterType, 'tria');
    h = triang(w)/sum(triang(w));
elseif strcmp(FilterType,'mean')
    h = ones(w,1)./w;
elseif strcmp(FilterType,'gaus')
    h =gausswin(w)./sum(gausswin(w));
elseif strcmp(FilterType,'1-2-1')
    if w>3
       error('need w=3')
    end
    h = [1 2 1]'./4;
elseif strcmp(FilterType,'1-4-1')
    if w>3
       error('need w=3')
    end
    h = [1 4 1]'./6;    
elseif strcmp(FilterType,'wrdf')
    h=(1:w)'/sum(1:w);
elseif strcmp(FilterType,'back')    
    h = ones(w,1)./w;
else    
    error('Unrecognized smoothing window');
end
%disp('Reminder: Only use odd numbers for filter length');

Xsmooth = nan(size(X));
t1 = ceil(w/2);
tend = size(X,1)-floor(w/2)-1;
w2 = floor(w/2);

if strcmp(FilterType,'back')    
    for i = w+1:size(X,1);
        q = i-w+1:i;
        qrec(i,:) = q;
        Xsmooth(i,:) = X(q,:)'*h;
    end
else    
    for i = t1:tend

        q = i-w2:i+w2;
        qrec(i,:) = q;
        Xsmooth(i,:) = X(q,:)'*h;
    end
end