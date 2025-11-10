function [Accuracy, predictLabel, curBlockLabel] = testModel_test(curBlockData, curBlockLabel, opt)

% 结果测试

predictLabel = zeros(size(curBlockData,1),1);
opt.nClass = numel(unique(curBlockLabel));

parfor iData = 1:size(curBlockData,1)
    curData = squeeze(curBlockData(iData,:,:));
    curDataPredictLabel = testFeaturePSD(curData, opt.model_fortest, opt);
    predictLabel(iData) = curDataPredictLabel;
end


Accuracy = sum(predictLabel == curBlockLabel)/numel(curBlockLabel);

