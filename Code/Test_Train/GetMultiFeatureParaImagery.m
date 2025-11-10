function multiFeatureModel = GetMultiFeatureParaImagery(curSelTrainFeatureMat, curTrainLabel,...
                                                        iFeature, opt)

curSelFeatureCat = [];  % Trial x (4*iFeature)
for i = 1:iFeature
    curSelFeatureCat = cat(2,curSelFeatureCat,curSelTrainFeatureMat{i});
end

trainFunc = opt.AlignTrainFunc;
multiFeatureModel = trainFunc(curSelFeatureCat, curTrainLabel, opt);


end

