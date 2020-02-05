function result = recog(test_img,pnsh)
    global train_imgs
    global tr_frames
    global tr_descr
    %% Pre-processing
    img_diag = im_getsize(test_img);
    SE = strel('sphere',round(0.085*img_diag));
    test_img = imdilate(test_img,SE);
    figure
    imshow(test_img)
% %     H = is_holes(test_img);
% %     pnsh = H.*pnsh;

    test_img = single(255.*test_img);
%% SIFT features
    [test_frame, test_descr] = vl_sift(test_img,'PeakThresh',0,'edgethresh',10);
%% Initializing matching
    spl_amount = size(tr_frames,2);
    match_scores = zeros(10,spl_amount);
%% Matching and scoring
for i_num = 1:10

    for i_spl = 1:spl_amount
        % Pick out the frames, descrs from the stored cell
        ref_frame = tr_frames{i_num,i_spl};
        ref_descr = tr_descr{i_num,i_spl};
        % ubc_matching
        [matches,scores] = vl_ubcmatch(test_descr, ref_descr, 1.6);
        if size(matches,2)==0
%             fprintf("Matched to %d, 0 mathces. \n",i_num);
            continue
        end
        raw_matches_no = size(matches,2);
        
        %% Post treatment (matches trimming)
        [matches,scores] = match_trim(matches, scores);
        % Pick out the valid-matched frames
        test_fr_matched = test_frame(:,matches(1,:));
        ref_fr_matched = ref_frame(:,matches(2,:));
        % Rotation binning
        [test_fr_matched, ref_fr_matched] = rota_binning(test_fr_matched,ref_fr_matched);
        r = get_scaleratio(test_fr_matched,ref_fr_matched);
% Matche plot
% %         if i_num == 6 & i_spl == 5
% %             h = match_plot(test_img, 255.*train_imgs{i_num,i_spl}, test_fr_matched, ref_fr_matched);
% %         end
        %% Score calculation
        scl_t = r.*test_fr_matched(3,:);
        scl_r = ref_fr_matched(3,:);
        score_i = sum(scl_t.*scl_r - 1.5.*((scl_t.^2 + scl_r.^2).^0.50));
        match_scores(i_num,i_spl) = score_i;
%         fprintf('Matched to %d, %d matches, score = %f. \n',i_num,size(scl_t,2),score_i);
    end
end
%% Post-treatment on scores got above
% match_scores %for debug
match_scores = real(match_scores);
output = zeros(10,2);

for i = 1:10
    output(i,1) = i;
    output(i,3) = sum(match_scores(i,:))-max(match_scores(i,:));
%     fprintf("Avg score matched to %d = %f. \n",i,output(i,2));
end
output(:,3) = output(:,3)./pnsh;
sum_scores = sum(output(:,3));
result = sortrows(output,3,'descend');
result(:,2) = round(result(:,3).*100./sum_scores,2);
result = result(1:3,1:2);
end