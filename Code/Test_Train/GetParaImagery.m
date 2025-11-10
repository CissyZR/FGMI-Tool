function ParaImagery = GetParaImagery(ImageData, ImageLabel, opt)
ParallelFlag = opt.ParallelFlag;
% CSP_Config = opt.CSP_Config;
nClass = opt.nClass;
nCSP = opt.CSP_Config.nCSP;
nTrial = numel(ImageLabel);
CFTSInfo_Cell = opt.CFTSInfo_Cell;

% filterBankPara = opt.filterBankPara;

%% get CFTS Information
% tic;
CFTSInfo_VecCell = CFTSInfo_Cell(:);
% disp(['FCT Information Collected! Time:' num2str(toc) 's']);

%% FB特征提取
tic;
VarMapImageData = zeros(numel(CFTSInfo_VecCell), nCSP*2*nchoosek(nClass,2), nTrial); 
Wcsp = cell(1, numel(CFTSInfo_VecCell));
if ParallelFlag
    parfor iCFTS = 1:numel(CFTSInfo_VecCell)   % parfor
        curData = getCFTSData(ImageData, CFTSInfo_VecCell{iCFTS});
        [VarMapImageData(iCFTS, :, :), ~, Wcsp{iCFTS}] = FilterBankFeatureExt(curData, [], ImageLabel, [], opt);
        disp(['Extrating Features... iCFTS = ' num2str(iCFTS) '/' num2str(numel(CFTSInfo_VecCell)) ', Block: ' num2str(opt.iBlock)]);
    end
else
    for iCFTS = 1:numel(CFTSInfo_VecCell)
        curData = getCFTSData(ImageData, CFTSInfo_VecCell{iCFTS});
        [VarMapImageData(iCFTS, :, :), ~, Wcsp{iCFTS}] = FilterBankFeatureExt(curData, [], ImageLabel, [], opt);
        disp(['Extrating Features... iCFTS = ' num2str(iCFTS) '/' num2str(numel(CFTSInfo_VecCell)) ', Block: ' num2str(opt.iBlock)]);
    end
end
% clearvars DataTrainSeg DataTestSeg

parfor iTrail = 1:size(VarMapImageData,3)
    VarMapData = VarMapImageData(:, :, iTrail);
%     VarMapData = VarMapData./max(max(VarMapData));
%     VarMapData = VarMapData(logical(PatCspIdx{iPat}), :);
%     VarMapData = mapminmax(VarMapData,0,1);
%     FeatureMatTrain(:, :, 1, iTrail) = VarMapData;
    Feature2DMatTrain(:, :, 1, iTrail) = VarMapData;
    VarMapData = VarMapData';
    FeatureMatTrain(1, :, 1, iTrail) = VarMapData(:);
end

PatFeature.FeatureMatTrain = FeatureMatTrain;
PatFeature.Feature2DMatTrain = Feature2DMatTrain;
PatFeature.DataTrainLabel = ImageLabel;

ParaImagery.Wcsp = Wcsp;    % Wcsp

disp(['特征提取完成 ，用时' num2str(toc) '秒']);

%% Load Feature Selection Index
accMat = {};
PatCspIdx = {};
ParaImagery.accMat = accMat;
ParaImagery.PatCspIdx = PatCspIdx;

parfor iTrail = 1:size(Feature2DMatTrain,4)
    VarMapData = Feature2DMatTrain(:, :, 1, iTrail);
    VarMapData = VarMapData';        
    FeatureMatTrainForSVM(iTrail,:) = VarMapData(:);
    FeatureMatTrainForSVM_CFTS(iTrail,:,:) = VarMapData;
    
end

% for iTrail = 


%% Train SVM
tic;
Trained_LSVM_Cell = cell(size(FeatureMatTrainForSVM_CFTS,3),1);
FeatureMatTrainCell = cell(size(FeatureMatTrainForSVM_CFTS,3),1);

if ParallelFlag
    parfor iCFTS = 1:size(FeatureMatTrainForSVM_CFTS,3)
        Trained_LSVM_Cell{iCFTS} = trainAlignLinear_multiclassSVM_TernaryComplete(FeatureMatTrainForSVM_CFTS(:,:,iCFTS), ImageLabel, opt);
        FeatureMatTrainCell{iCFTS} = FeatureMatTrainForSVM_CFTS(:,:,iCFTS);    % FeatureMatTrainCell 每个cell: Trial x 4
    end
else
    for iCFTS = 1:size(FeatureMatTrainForSVM_CFTS,3)
        Trained_LSVM_Cell{iCFTS} = trainAlignLinear_multiclassSVM_TernaryComplete(FeatureMatTrainForSVM_CFTS(:,:,iCFTS), ImageLabel, opt);
        FeatureMatTrainCell{iCFTS} = FeatureMatTrainForSVM_CFTS(:,:,iCFTS);    % FeatureMatTrainCell 每个cell: Trial x 4
    end
end

ParaImagery.Trained_LSVM_Cell = Trained_LSVM_Cell;
ParaImagery.FeatureMatTrainCell = FeatureMatTrainCell;
disp(['Classifier Trained! Time:' num2str(toc) 's']);



