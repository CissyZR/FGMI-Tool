function Mdl1 = trainAlignLinear_multiclassRidge_TernaryComplete(XTrain, YTrain, opt)
XTrain = XTrain';
YTrain = categorical(YTrain);

multiClassModel_templete = templateLinear('Regularization','ridge','Lambda',opt.Lambda);
Mdl1 = fitcecoc(XTrain,YTrain,'Learners',multiClassModel_templete,'Coding','ternarycomplete','ObservationsIn','columns');

Mdl1 = (compact(Mdl1));


end


