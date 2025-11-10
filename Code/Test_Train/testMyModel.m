function [meanAccuracy, predictLabel, curBlockLabel] = testMyModel(DataAllPat, LabelAllPat, opt)

% load('BCI2005IIIa_FormatTestData_4Class_1.mat', 'DataAllPat', 'LabelAllPat');

% testPersonIdx = 1;

% for iPerson = 1:numel(testPersonIdx)
% curPersonIdx = testPersonIdx(iPerson);
nBlock = numel(DataAllPat{1});
opt.modelSavePath = fullfile(opt.Path.pathpwd, 'outputModels');
load(fullfile(opt.modelSavePath, ['model_final.mat']),...
    'trainModel');

curBlockAccuracy = zeros(nBlock, 1);
for iBlock = 1:nBlock
    curBlockData = DataAllPat{1}{iBlock};
    curBlockLabel = LabelAllPat{1}{iBlock};
    predictLabel = zeros(size(curBlockData,1),1);
    opt.nClass = numel(unique(curBlockLabel));
    % parfor
    parfor iData = 1:size(curBlockData,1)
        curData = squeeze(curBlockData(iData,:,:));
        curDataPredictLabel = testFeaturePSD(curData,trainModel, opt);
        predictLabel(iData) = curDataPredictLabel;
    end
    curBlockAccuracy(iBlock) = sum(predictLabel == curBlockLabel)/numel(curBlockLabel);

end

meanAccuracy = mean(curBlockAccuracy);


end

% finalMeanAccuracy = mean(meanAccuracy);

