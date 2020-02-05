function img = im_resize(img)
%Input is a black bg bw picture, resize to standard pic, and rows to 5400
%pixels
%img = not(img);
%find img limits
clms1 = (sum(img)>0);
rows1 = (sum(img,2)>0);
x11 = find(clms1,1,'first');
x12 = find(clms1,1,'last');
y11 = find(rows1,1,'first');
y12 = find(rows1,1,'last');
%crop
img = img(y11:y12,x11:x12);
%resize
dig = sqrt((x12-x11)^2+(y12-y11)^2);
dig_ratio = 350/dig;
img=imresize(img,dig_ratio,'nearest');
%img pad
img = padarray(img,[40,60]);
[szy,szx] = size(img);

%extend the canvas to 400 if not so
if szy<400
    pad_sz = (400-szy)/2;
    if mod(400-szy,2)==0
        img = padarray(img,pad_sz,'both');
    else
        pad_sz = round(pad_sz);
        img = padarray(img,pad_sz,'pre');
        img = padarray(img,pad_sz-1,'post');
    end
end




end