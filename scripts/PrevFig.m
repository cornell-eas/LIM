function PrevFig(figh)

PaperSize=get(figh,'PaperSize');
stdsize=[560.0000  464.0000  324.5455  420.0000]*2;
h2w=PaperSize(1)/PaperSize(2);


PaperPosition=get(figh,'PaperPosition');

wfract=PaperPosition(3)./PaperSize(1);
hfract=PaperPosition(4)./PaperSize(2);


set(figh,'pos',[50 50 stdsize(3)*wfract stdsize(4)*hfract])
figure(gcf);