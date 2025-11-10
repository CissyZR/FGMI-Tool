function [meanAccuracy, sepAccuracy] = getResult(TrueLabel, PredictLabel, opt)
    nModel = size(PredictLabel,2);
    sepAccuracy = zeros(nModel, 1);
    for iModel = 1:nModel
        curLabel = PredictLabel(:,iModel);
        sepAccuracy(iModel) = sum(TrueLabel == curLabel)./numel(TrueLabel);
    end
    meanAccuracy = mean(sepAccuracy, 'all');
    
end
