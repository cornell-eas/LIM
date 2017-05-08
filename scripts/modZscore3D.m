function [modZ3D,refMn2D,refStd2D]=modZscore3D(X3D,time,tRefEdges)
%[modZ3D,refMn2D,refStd2D]=modZscore3D(X3D,time,tRefEdges)

[nx,ny,nt]=size(X3D);
if length(tRefEdges)~=2
    error('length(tRefEdges)~=2')
end
tqRef=find(time>=tRefEdges(1) & time<=tRefEdges(2));
refMn2D=nanmean(X3D(:,:,tqRef),3);
refStd2D=nanstd(X3D(:,:,tqRef),[],3);
modZ3D=nan(size(X3D));
for i =1:nx
    for j =1:ny
        modZ3D(i,j,:)=(X3D(i,j,:)-refMn2D(i,j))./refStd2D(i,j);
    end
end
