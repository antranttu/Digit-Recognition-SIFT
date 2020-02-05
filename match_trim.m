function [M,S] = match_trim (match,score)
tb = cat(1,match,score);
[C,ia,ic] = unique(tb(2,:));
TB = [];
for i = 1:length(ia)
    idx = find(ic==i);
    if length(idx)==1
        TB(:,end+1) = tb(:,idx);
    else
        STB = (tb(:,idx))';
        STB = sortrows(STB,3,'descend');
        TB(:,end+1) = (STB(1,:))';
    
end
M = TB(1:2,:);
S = TB(3,:);

end