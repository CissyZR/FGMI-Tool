function [PredictLabel, FeatureMat] = PredictSingleTrail(ParaImagery, ImageData, opt)
ParallelFlag = opt.ParallelFlag;
% SelFlag = opt.SelFlag;
% CSP_Config = opt.CSP_Config;
% nCSP = opt.nCSP;
CFTSInfo_Cell = opt.CFTSInfo_Cell;
nTrial = size(ImageData,1);

%% Get CFTS information
% tic;
CFTSInfo_VecCell = CFTSInfo_Cell(:);
% disp(['FCT Information Collected! Time:' num2str(toc) 's']);

%% Extract features
tic;
ParaImagery_Wcsp = ParaImagery.Wcsp;
parfor iCFTS = 1:numel(CFTSInfo_VecCell)
    curData = getCFTSData(ImageData, CFTSInfo_VecCell{iCFTS});
    Wcsp = ParaImagery_Wcsp{iCFTS};
    [VarMapImageData(iCFTS, :, :), ~, ~] = FilterBankFeatureExt(curData, [], [], [], opt, Wcsp);
end
disp(['Extracted Features. Time: ' num2str(toc) 's']);

for iTrail = 1:nTrial
    VarMapData = VarMapImageData(:, :, iTrail);
%     VarMapData = VarMapData./max(max(VarMapData));
%     VarMapData = VarMapData(logical(PatCspIdx{iPat}), :);
%     VarMapData = mapminmax(VarMapData,0,1);
%     FeatureMatTrain(:, :, 1, iTrail) = VarMapData;
    Feature2DMatTrain(:, :, 1, iTrail) = VarMapData;
    VarMapData = VarMapData';
    FeatureMatTrain(1, :, 1, iTrail) = VarMapData(:);
end

for iTrail = 1:nTrial
    VarMapData = Feature2DMatTrain(:, :, 1, iTrail);
    VarMapData = VarMapData';        
    FeatureMatTrainForSVM(iTrail,:) = VarMapData(:);
    FeatureMatTrainForSVM_TFS(iTrail,:,:) = VarMapData;
    
end

%% Train SVM
PredictLabel = zeros(size(FeatureMatTrainForSVM_TFS,1), size(FeatureMatTrainForSVM_TFS,3));
% PredictScore = zeros(size(FeatureMatTrainForSVM_TFS,1), 2, size(FeatureMatTrainForSVM_TFS,3));

FeatureMatTestCell = cell(size(FeatureMatTrainForSVM_TFS,3),1);
if ParallelFlag
    parfor iCFTS = 1:size(FeatureMatTrainForSVM_TFS,3)
        PredictLabel(:,iCFTS) = double(predict(ParaImagery.Trained_LSVM_Cell{iCFTS}, FeatureMatTrainForSVM_TFS(:,:,iCFTS)));
        FeatureMatTestCell{iCFTS} = FeatureMatTrainForSVM_TFS(:,:,iCFTS);    % FeatureMatTrainCell 每个cell: Trial x 4

    end
else
    for iCFTS = 1:size(FeatureMatTrainForSVM_TFS,3)
        PredictLabel(:,iCFTS) = predict(ParaImagery.Trained_LSVM_Cell{iCFTS}, FeatureMatTrainForSVM_TFS(:,:,iCFTS));
        FeatureMatTestCell{iCFTS} = FeatureMatTrainForSVM_TFS(:,:,iCFTS);    % FeatureMatTrainCell 每个cell: Trial x 4

    end
end

FeatureMat.FeatureMatTestCell = FeatureMatTestCell;


