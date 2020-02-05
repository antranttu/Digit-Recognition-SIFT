
%% Pre-processing
test_img = not(im2bw(imread('./test/6-1.jpg')));
ref_img = not(im2bw(imread('./test/6-2.jpg')));
test_img = single(255.*test_img);
ref_img = single(255.*ref_img);
figure
subplot(1,2,1)
imshow(test_img)
title('Original test image')
subplot(1,2,2)
imshow(ref_img)
title('Reference image')
%% SIFT features
[test_frame, test_descr] = vl_sift(test_img,'PeakThresh',0,'edgethresh',10);
[ref_frame, ref_descr] = vl_sift(ref_img,'PeakThresh',0,'edgethresh',10);
subplot(1,2,1)
h1 = vl_plotframe(test_frame);
set(h1,'color','y','linewidth',2) ;

subplot(1,2,2)
h2 = vl_plotframe(ref_frame);
set(h2,'color','y','linewidth',2) ;

%% Matching and scoring

% ubc_matching
[matches,scores] = vl_ubcmatch(test_descr, ref_descr, 1.2);
if size(matches,2)==0
    fprintf("Matched to %d, 0 mathces. \n",i_num);
end
raw_matches_no = num2str(size(matches,2));

test_fr_matched = test_frame(:,matches(1,:));
ref_fr_matched = ref_frame(:,matches(2,:));

h3 = match_plot(test_img, ref_img, test_fr_matched, ref_fr_matched);
title("ubc raw matches: "+raw_matches_no+" matches are found.");
%% Post treatment (matches trimming)
[matches,scores] = match_trim(matches, scores);
test_fr_matched = test_frame(:,matches(1,:));
ref_fr_matched = ref_frame(:,matches(2,:));
h4 = match_plot(test_img, ref_img, test_fr_matched, ref_fr_matched);
matches_no = num2str(size(test_fr_matched,2));
title("Matches after matches trimming: "+matches_no+" matches are preserved.")
% Rotation binning
[test_fr_matched, ref_fr_matched] = rota_binning(test_fr_matched,ref_fr_matched);
r = get_scaleratio(test_fr_matched,ref_fr_matched);
h5 = match_plot(test_img, ref_img, test_fr_matched, ref_fr_matched);
matches_no = size(test_fr_matched,2);
ttl_str=sprintf("Matches after rotation binning: %d.\nThe scale ratio median is %f",...
    matches_no,r);
title(ttl_str)

