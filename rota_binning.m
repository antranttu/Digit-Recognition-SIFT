function [F1,F2] = rota_binning (frame_1,frame_2)
arc_diff = frame_1(4,:) - frame_2(4,:);
y = sin(arc_diff);
x = cos(arc_diff);
sum_y = sum(y);
sum_x = sum(x);
ornt = atan(sum_y/sum_x);
idx = find(arc_diff>ornt-0.6 & arc_diff<ornt+0.6);
F1 = frame_1(:,idx);
F2 = frame_2(:,idx);

end