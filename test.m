%you need to manually define 'data' and 'label' first, and save them in
%file 'dataandlabel.mat'
addpath('./mi');
load dataandlabel.mat data label
%result=featureselection(label,data);

OUT=[];
INDEX_tfidf=[];
INDEX_mrmr=[];
accuracy=[];
auc=[];

figure, hold on
ii=round(numel(label)*0.8);%number of samples for each run
for jj=1:2000
    rp=randperm(numel(label));
    rp=rp(1:ii);
    out=[];
    INDEX1=[];
    INDEX2=[];
    try
        for kk=1:ii
            testrp=rp(kk);
            trainrp=setdiff(rp,testrp);
            gg=label(trainrp);
            
            index_tfidf=qintfidf(data(trainrp,:));%tfidf
            index_mrmr=qinmrmr(data(trainrp,:),gg);%mrmr
            INDEX1=[INDEX1;index_tfidf];
            INDEX2=[INDEX2;index_mrmr];
            
            output=[];
            method={'tfidf';'mrmr'};
            for i=1:2
                eval(['index=index_',method{i},';'])
                class=mysvmclassify(mysvmtrain(data(trainrp,index),label(trainrp)),data(testrp,index));
                output=[output,class];%output: [tfidf_class,mrmr_class]
            end
            out=[out;output,label(testrp)];%output: [tfidf_class,mrmr_class,groundtruth]
        end
        
        accuracy=[accuracy;mean(out(:,1)==out(:,3)),mean(out(:,2)==out(:,3))];
        auc=[auc;roc_tracing3(out(:,1)>0,out(:,3)>0),roc_tracing3(out(:,2)>0,out(:,3)>0)];
        OUT=[OUT;out];%[tfidf-class,mrmr-class,groundtruth]
        INDEX_tfidf=[INDEX_tfidf;INDEX1];
        INDEX_mrmr=[INDEX_mrmr;INDEX2];
        
        figure(1),hold on,plot(ii,jj,'ro')
        
    catch exception
    end
    figure(1),hold on,plot(ii,jj,'b*')
    if size(accuracy,1)>=20
        break
    end
end

accuracy_mstd=[mean(accuracy),std(accuracy)];
auc_mstd=[mean(auc),std(auc)];

u=unique(INDEX_tfidf);
u=reshape(u,numel(u),1);
for i=1:numel(u)
    u(i,2)=sum(INDEX_tfidf==u(i,1))/numel(label)/20;
end
[~,i]=sort(u(:,2),'descend');
u=u(i,:);
result.tfidf=u;
u=unique(INDEX_mrmr);
u=reshape(u,numel(u),1);
for i=1:numel(u)
    u(i,2)=sum(INDEX_mrmr==u(i,1))/numel(label)/20;
end
[~,i]=sort(u(:,2),'descend');
u=u(i,:);
result.mrmr=u;
result.OUT=OUT;
result.accuracy=accuracy;
result.auc=auc;
result.accuracy_mstd=accuracy_mstd;
result.auc_mstd=auc_mstd;

close all
clear i gg ii jj kk index class output outputr out outr posterior rp
clear testrp trainrp trainrp_train trainrp_test exception intest intrain
clear auc accuracy aucr accuracyr auc1r auc2r auc3r auc1 auc2 auc3 auc4 auc4r
clear index* final* o* t method ans INDEX*
clear OUT accurac auc accuracy_mstd auc_mstd u

save filename.mat label data result
