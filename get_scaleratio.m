%% Measure the scale ratios
function scale_ratio = get_scaleratio(test_frame,ref_frame)
rts = ref_frame(3,:)./test_frame(3,:);
scale_ratio = median(rts);
end