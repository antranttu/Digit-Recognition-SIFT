%% Cross-Valid finding training and testing sets
clear;
rng(1234);
run('C:\Program Files\MATLAB\vlfeat\toolbox\vl_setup');

load('descriptors');
load('features');
for i = 1:10
    a = 0;
    for j = 1:size(features_all,2)
        a = a+size(features_all{i,j},2);
    end
    pnsh(i)=a/10;
end
pnsh = pnsh';
%5-folds for 55 samples
perms = randperm(55);%How to use random seed? I forgot
full_record = [];
raw_record = [];

for i = 1:5
    test_idx = perms(11*(i-1)+1:11*i); % indices used for testing
    tr_idx = cat(2,perms(1:11*(i-1)),perms(11*i+1:end)); % indices used for training
    tr_descrs = descriptors_all(:,tr_idx); % descriptors of training indices
    tr_frames = features_all(:,tr_idx); % features of training indices
    test_descrs = descriptors_all(:,test_idx); % descriptors of testing indices
    test_frames = features_all(:,test_idx); % features of training indices
    tr_spl_amount = size(tr_frames,2); % number of samples used for training

    for i_test_spl = 1:size(test_frames,2)
        for i_test_number = 1:10
            test_descr = test_descrs{i_test_number,i_test_spl}; 
            test_frame = test_frames{i_test_number,i_test_spl};
            match_scores = zeros(10,tr_spl_amount);
            raw_matches_no = zeros(10,tr_spl_amount);
            total_raw_matches = zeros(10,1);
            
%% 
            for i_num = 1:10
                for i_spl = 1:tr_spl_amount
                    % Pick out the frames, descrs from the stored cell.
                    % Compare the Test Image descriptor with each of the
                    % Train Descriptor in cell array.
                    ref_frame = tr_frames{i_num,i_spl};
                    ref_descr = tr_descrs{i_num,i_spl};
                    % ubc_matching
                    [matches,scores] = vl_ubcmatch(test_descr, ref_descr, 2);
                    if size(matches,2)==0
            %             fprintf("Matched to %d, 0 mathces. \n",i_num);
                        continue
                    end
                    raw_matches_no(i_num,i_spl) = size(matches,2); 
                    total_raw_matches(i_num,1) = sum(raw_matches_no(i_num,:));
                                     
                    %% Post processing (matches trimming)
                    [matches,scores] = match_trim(matches, scores); % get rid of the repeated matches on the same location
                    % Pick out the valid-matched features
                    test_fr_matched = test_frame(:,matches(1,:)); % indices of matched frames in test
                    ref_fr_matched = ref_frame(:,matches(2,:)); % indices of matched frames in reference
                    % Rotation binning
                    [test_fr_matched, ref_fr_matched] = rota_binning(test_fr_matched,ref_fr_matched); % onlytake 
                                                                                                      % matches within
                                                                                                      % specific angles
                    r = get_scaleratio(test_fr_matched,ref_fr_matched); % median scale ratio?
            %         if i_num == 6% & i_spl == 5
            %             h = match_plot(test_img, 255.*train_imgs{i_num,i_spl}, test_fr_matched, ref_fr_matched);
            %         end
                    %% Score calculation
                    scl_t = r.*test_fr_matched(3,:);
                    scl_r = ref_fr_matched(3,:);
                    score_i = sum(scl_t.*scl_r - 1.5*((scl_t.^2 + scl_r.^2).^0.5));
                    %score_i = size(test_fr_matched,2);
                    match_scores(i_num,i_spl) = score_i;
            %         fprintf('Matched to %d, %d matches, score = %f. \n',i_num,size(scl_t,2),score_i);
                end
            end
            
            % Raw accuracy before post processing
            output_raw = zeros(10,2);
            for i = 1:10
                output_raw(i,1) = i;
                output_raw(i,2) = total_raw_matches(i);
            %     fprintf("Avg score matched to %d = %f. \n",i,output(i,2));
            end
            raw_result = sortrows(output_raw,2,'descend');
            raw_result = raw_result(1);
            if raw_result == i_test_number
                %fprintf('Correct, %d -> %d\n',result, result);
                raw_record(end+1) = 1;
            else
                %fprintf('Wrong, %d -> %d\n', i_test_number, result);
                raw_record(end+1) = 0;

            end
            
            % Accuracy based on after post processing
            match_scores = real(match_scores);
            output = zeros(10,2);
            
            for i = 1:10
                output(i,1) = i;
                output(i,2) = sum(match_scores(i,:))-max(match_scores(i,:));
            %     fprintf("Avg score matched to %d = %f. \n",i,output(i,2));
            end
            output(:,2) = output(:,2)./pnsh;
            result = sortrows(output,2,'descend');
            result = result(1);
            if result == i_test_number
                %fprintf('Correct, %d -> %d\n',result, result);
                full_record(end+1) = 1;
            else
                %fprintf('Wrong, %d -> %d\n', i_test_number, result);
                full_record(end+1) = 0;

            end
        end
    end
end
raw_accuracy = (sum(raw_record)/length(raw_record))*100
final_ccuracy = (sum(full_record)/length(full_record))*100



