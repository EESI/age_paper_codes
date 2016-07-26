%you need to manually define 'data' and 'label' first, and save them in
%file 'dataandlabel.mat'
addpath('./mi');
load dataandlabel.mat data label
result=featureselection(label,data);
save filename.mat label data result
