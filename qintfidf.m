function finalindex=qintfidf(count)% tf-idf feature selection

all=count;
countr=count./repmat(sum(count')',1,size(count,2));
index1=find(sum(all));
tfidf=[];
all2=logical(all);
for i=index1
    l1=sum(countr(:,i));
    l2=log10((size(all,1))/sum(all2(:,i)));
    tfidf=[tfidf,l1*l2];
end
[~,index2]=sort(-tfidf);
finalindex=index1(index2(1:10))';