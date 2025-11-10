function [predictLabel, predictScore] = PredictMultiFeatureSingleTrail(multiFeatureModel,...
                                                        curSelTestFeatureMat, DataTestLabel,...
                                                        iFeature, opt)

curSelFeatureCat = [];  % Trial x (4*iFeature)
for i = 1:iFeature
    curSelFeatureCat = cat(2,curSelFeatureCat,curSelTestFeatureMat{i});
end


[predictLabel, predictScore] = predict(multiFeatureModel, curSelFeatureCat);



end