function [Accuracy, predictLabel, curBlockLabel] = testMyModel_train(curBlockData, curBlockLabel, opt)
% 计算测试数据在交叉验证的平均结果

predictLabel = zeros(size(curBlockData,1),1);
opt.nClass = numel(unique(curBlockLabel));

parfor iData = 1:size(curBlockData,1)
    curData = squeeze(curBlockData(iData,:,:));
    curDataPredictLabel = testFeaturePSD(curData, opt.model_fortestcross, opt);
    predictLabel(iData) = curDataPredictLabel;
end
Accuracy = sum(predictLabel == curBlockLabel)/numel(curBlockLabel);
end