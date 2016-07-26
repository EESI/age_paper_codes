function finalindex=qinmrmr(count,class)%mrmr using mrmr_mid_d.m

index1=find(sum(count));
all=count(:,index1);
miu=mean(all);
sigma=std(all);
thre1=miu-sigma;
thre2=miu+sigma;
[a,b]=size(all);
thre1=repmat(thre1,a,1);
thre2=repmat(thre2,a,1);
all2=ones(a,b);
all2((all-thre1)<0)=0;
all2((all-thre2)>0)=2;
index2=mrmr_mid_d(all2,class,10);
finalindex=index1(index2)';