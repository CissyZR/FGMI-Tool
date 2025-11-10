function Mdl1 = trainAlignLinear_multiclassLasso_TernaryComplete(XTrain, YTrain, opt)
XTrain = XTrain';
YTrain = categorical(YTrain);

multiClassModel_templete = templateLinear('Regularization','lasso','Lambda',opt.Lambda);
Mdl1 = fitcecoc(XTrain,YTrain,'Learners',multiClassModel_templete,'Coding','ternarycomplete','ObservationsIn','columns');

Mdl1 = (compact(Mdl1));


end


