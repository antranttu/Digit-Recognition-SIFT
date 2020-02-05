%% measure the diag
function [diag_length] = im_getsize(img)
%input is a black bg bw image
clms1 = (sum(img)>0);
rows1 = (sum(img,2)>0);
x11 = find(clms1,1,'first');
x12 = find(clms1,1,'last');
y11 = find(rows1,1,'first');
y12 = find(rows1,1,'last');

%resize
diag_length = sqrt((x12-x11)^2+(y12-y11)^2);
%350 -> 12
end