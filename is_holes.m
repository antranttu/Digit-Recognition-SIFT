%% is there a hole?
function pnsh_crr = is_holes(img)
[labeledImage, numberOfObject1] = bwlabel(img);
[labeledImage, numberOfObject2] = bwlabel(not(img));
% numberOfObject1,numberOfObject2
H = abs(numberOfObject1 - numberOfObject2)
    if H==2
        pnsh_crr = [10,10,10,5,10,5,10,1,10,5]';
    else
        if H==0
        pnsh_crr = [1,1,1,1,1,10,1,10,10,10]';
        else 
        pnsh_crr = [10,10,10,1,10,1,10,1,1,1]';
        end
    end
end

