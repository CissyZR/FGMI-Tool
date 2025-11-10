function Mdl1 = trainAlignLinear_multiclassSVM_TernaryComplete(XTrain, YTrain, opt)
if numel(unique(YTrain)) == 2
    YTrain = categorical(YTrain);
    Mdl1 = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear');

else
    YTrain = categorical(YTrain);
    multiClassSVM_templete = templateSVM('KernelFunction', 'linear');
    Mdl1 = fitcecoc(XTrain,YTrain,'Learners',multiClassSVM_templete,'Coding', 'ternarycomplete');

end

Mdl1 = discardSupportVectors(compact(Mdl1));

end


