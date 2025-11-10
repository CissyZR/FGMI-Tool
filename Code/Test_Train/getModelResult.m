function res = getModelResult(cspData, trainModel, opt)
%% 
% tic;
trainedClassifier = trainModel.Classifier;
selTFSInfo = trainModel.SelTFSInfo';
resLabel = zeros(size(trainedClassifier));
resScore = zeros([size(trainedClassifier) opt.nClass]);
nBlock = size(trainedClassifier,2);
for iM = 1:numel(selTFSInfo)
    curSelTFS = selTFSInfo{iM};
    for iBlock = 1:nBlock
        curCSPData = cspData(:,curSelTFS,iBlock);   % 4 x 13
        curCSPData = curCSPData(:)';
        if isequal(class(trainedClassifier{iM, iBlock}), 'SeriesNetwork')
            [resLabel(iM, iBlock), resScore(iM, iBlock, :)] = classify(trainedClassifier{iM, iBlock}, curCSPData);
        else
            [resLabel(iM, iBlock), resScore(iM, iBlock, :)] = predict(trainedClassifier{iM, iBlock}, curCSPData);
        end
    end
end
% disp(['Classification. Time: ' num2str(toc) 's']);

resScoreMean = squeeze(mean(resScore, [1 2]));
[~, res_maxIdx] = max(resScoreMean);
res = res_maxIdx;

% res_tbl = tabulate(resLabel(:));
% [~, res_maxIdx] = max(res_tbl(:,2));
% res = res_tbl(res_maxIdx, 1);

end


