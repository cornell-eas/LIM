function fig4doc(sizestr,filename,varargin)
% fig4doc(sizestr,outfilename,fighandle,resolution,printertype)

if length(varargin)==0
	figh=gcf;
	res='300';
        printertype='-painters';

elseif length(varargin)==1
	figh=varargin{1};
	res='300';
        printertype='-painters';

elseif length(varargin)==2
	figh=varargin{1};
	res=num2str(varargin{2});
        printertype='-painters';

elseif length(varargin)==3
	figh=varargin{1};
	res=num2str(varargin{2});
        printertype=varargin{3};

end

width=sizestr(1);
h=str2num(sizestr(2:end));

if width=='h' %half width, 3.25in
	w=3.25;
elseif width=='f' %full page, 
	w=6.5;
elseif width=='d' %dissertation width, 
	w=6;
else
	error('unkown figure width')
end
figure(figh)

set(figh,'paperposition',[1 1 w h])
PrevFig(figh)
%     print('-depsc2',['-r' res],'-loose',[filename '.eps'],printertype)
print('-dpng',['-r' res],'-loose',[filename '.png'])
% print('-djpeg',['-r' res],'-loose',[filename '.jpg'])
% print('-dtiff',['-r' res],'-loose',[filename '.tiff'])
%print('-depsc2',['-r' res],'-cmyk','-loose',filename,printertype)

% print_save(filename,'300')