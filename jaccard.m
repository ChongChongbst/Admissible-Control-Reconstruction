function [JI,FI,FE] = jaccard(g,data1,data2)



set1 = (data1<=0);
set2 = (data2<=0);

intsct = min(set1,set2);
unin = max(set1,set2);

vol_intersect = sum(intsct,'all');
vol_union = sum(unin,'all');
vol_g = prod(g.N, "all");

JI = vol_intersect/vol_union;
FI = sum(min(set1,~intsct),'all')/vol_g;
FE = sum(min(set2,~intsct),'all')/vol_g;

end