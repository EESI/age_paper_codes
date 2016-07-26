function output=roc_tracing3(apriori,correct_classes,plotstyle)

fragmentspergenome=numel(correct_classes);
numgenomes=1;

[apriori_sort,apriori_sortinds]= sort(apriori(:),'descend');  %sort likelihood scores

apriori_correct_class_sort=correct_classes(apriori_sortinds);  %sort likelihood "correct_class".  We can pass in the correct class to either be Groundtruth of Known/Unknown or "Classifier true" or whatever we like


tc=sum(sum(correct_classes)); %tc==total_correct
ti_apriori=length(apriori_correct_class_sort)-tc; %ti==total_incorrect


tp_apriori=zeros(fragmentspergenome*numgenomes,1); %true positives
fp_apriori=zeros(fragmentspergenome*numgenomes,1); %false positives
fn_apriori=zeros(fragmentspergenome*numgenomes,1); %false negatives
tn_apriori=zeros(fragmentspergenome*numgenomes,1); %true negatives


tp_apriori=cumsum(apriori_correct_class_sort);  %TP=Cumsum 'groundtruth' known/unknown 
fp_apriori=cumsum(~apriori_correct_class_sort); %FP=Invert Cumsum 'groundtruth' known/unknown to get FP 


unique_apriori=flipud(unique(apriori_sort));


%%%%%%%%%%%%%%%%%%%This is code I made to make sure that if there are redundant scores (the same scores), they get the same TP/FP values so they show up as ONE DOT on the ROC (and are not cumsummed)%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j=unique_apriori'
    initial=tp_apriori(min(find(apriori_sort==j)));
    final=tp_apriori(max(find(apriori_sort==j)));
    tp_apriori(apriori_sort==j)=initial;
    tp_apriori(max(find(apriori_sort==j)))=final;
    
    initial=fp_apriori(min(find(apriori_sort==j)));
    final=fp_apriori(max(find(apriori_sort==j)));
    fp_apriori(apriori_sort==j)=initial;
    fp_apriori(max(find(apriori_sort==j)))=final;
end


%%%%%%%%%%%%%%%%%%%End redundancy measure%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn_apriori=tc-tp_apriori;   %FN=total_correct-true_positive
tn_apriori=ti_apriori-fp_apriori;  %TN=total_incorrect-false_positive 


sensitivity_apriori=tp_apriori./(tp_apriori+fn_apriori);  %Sens=tp/(tp+fn)
specificity_apriori=tn_apriori./(fp_apriori+tn_apriori);  %Sens=tn/(tn+fp)

pred_rate=(tp_apriori + tn_apriori)./length(apriori);  % Accuracy
max(pred_rate)  %show me the max accuracy from the ROC (for fun)

auc_apriori=sum(diff(1-specificity_apriori).*(sensitivity_apriori(1:end-1)+sensitivity_apriori(2:end))/2)  %Compute area under the curve

if(nargin<3)
    plot(1-specificity_apriori,sensitivity_apriori)
hold on
%set(gca,'fontsize', 40);
ylabel('Sensitivity')
xlabel('1-Specificity')
%set(8, 'Position',[293 318 1055 627]);
%grid on;
%plot(0:1/(fragmentspergenome*numgenomes):1,0:1/(fragmentspergenome*numgenomes):1,'r')
else
%    plot(1-specificity_apriori,sensitivity_apriori,plotstyle)
end


%Best operating point computations


best_values_apriori=sensitivity_apriori+specificity_apriori;  %add both sens and spec together
best_apriori_threshold=apriori_sort(find(max(best_values_apriori)==best_values_apriori));  %get the score that gives the max of the combination (e.g. want value closest to 2)


best_sensitivity_apriori=sensitivity_apriori(find(max(best_values_apriori)==best_values_apriori))   %Go back and show what the Sensitivity of the best_threshold is
best_specificity_apriori=specificity_apriori(find(max(best_values_apriori)==best_values_apriori))   %Go back and show what the Specificity of the best_threshold is
best_passed_percentage=mean(apriori>best_apriori_threshold(1))

best_pred_rate = pred_rate(find(max(best_values_apriori)==best_values_apriori))



threshold=best_apriori_threshold(1)  %In case there are several points that are the "best threshold", take the first.  (This rarely happens)

output=[auc_apriori(1)];
% output=[sensitivity_apriori,specificity_apriori];
