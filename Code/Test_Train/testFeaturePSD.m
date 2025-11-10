function resultType = testFeaturePSD(testData,trainModel, opt)
% testData: ChxN e.g.:19x1000
tic;
cat_result = [];
opt.iClassifier = 0;
for iM = 1:numel(trainModel)
    Wcsp = cell(trainModel{iM}.restructInfo.Wcsp_shape);
    TFInfo = cell(trainModel{iM}.restructInfo.TFInfo_shape);
    useIdx = trainModel{iM}.restructInfo.useIdx;
    Wcsp(useIdx,:) = trainModel{iM}.Wcsp;
    TFInfo(useIdx) = trainModel{iM}.TFInfo;
    
    cspData = getCSPData(testData, Wcsp, TFInfo, useIdx, opt);
    
    for iClassifier = 1:numel(trainModel{iM}.ClassifierCell)
        opt.iClassifier = iClassifier;
        result = getModelResult(cspData, trainModel{iM}.ClassifierCell{iClassifier}, opt);
        cat_result = cat(1,cat_result,result);
    end
end
t = toc;
% disp(['Classification. Time: ' num2str(toc) 's']);

%% Êä³ö½á¹û
res_tbl = tabulate(double(cat_result(:)));
[~, res_maxIdx] = max(res_tbl(:,2));
resultType = res_tbl(res_maxIdx, 1);

% res = double(cat_result);
% [resultType, resultProb] = getFinalDecision(res);

disp(['Result: ' num2str(resultType) '. Time: ' num2str(t) 's. VL: ' num2str(cat_result')]);

end

