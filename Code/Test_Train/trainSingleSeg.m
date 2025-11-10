function trained_SingleSegPara = trainSingleSeg(DataPat, LabelPat, opt)
    nCFTS = numel(opt.CFTSInfo_Cell);
    nBlock = numel(DataPat);
    Acc = zeros(nBlock, nCFTS);
    DataTrainLabel_BlockCell = cell(1, nBlock);
    DataTestLabel_BlockCell = cell(1, nBlock);
    Trained_Wcsp_Cell = cell(nCFTS, nBlock);
    Trained_TrainFeature_Cell = cell(nCFTS, nBlock);
    Trained_TestFeature_Cell = cell(nCFTS, nBlock);
%     AccScore = zeros(nBlock, nCFTS);
    for iBlock = 1:nBlock
        [DataTrain, DataTrainLabel, DataTest, DataTestLabel] = getTrainTestData(DataPat, LabelPat, iBlock, opt);
        opt.iBlock = iBlock;
        ParaImagery = GetParaImagery(DataTrain, DataTrainLabel, opt);
        [PredictLabel, FeatureMat] = PredictSingleTrail(ParaImagery, DataTest, opt);
        parfor iCFTS = 1:nCFTS
            Acc(iBlock,iCFTS) = getResult(DataTestLabel, double(PredictLabel(:,iCFTS)), opt);
        end
        DataTrainLabel_BlockCell{iBlock} = DataTrainLabel;
        DataTestLabel_BlockCell{iBlock} = DataTestLabel;
%         Trained_LSVM_Cell(:,iBlock) = ParaImagery.Trained_LSVM_Cell;
        Trained_Wcsp_Cell(:,iBlock) = ParaImagery.Wcsp;
        Trained_TrainFeature_Cell(:,iBlock) = ParaImagery.FeatureMatTrainCell;
        Trained_TestFeature_Cell(:,iBlock) = FeatureMat.FeatureMatTestCell;

    end
    
    [sortedSingleCFTSAcc, sortedSingleCFTSScoreIdx] = sort(mean(Acc), 'descend');
%     [sortedAccScore, sortedAccScoreIdx] = sort(mean(Acc), 'descend');
%     [meanAcc, meanAccIdx] = max(mean(Acc));   % 

    selSortedIdx = sortedSingleCFTSScoreIdx;
    trainedWcsp = Trained_Wcsp_Cell; 
    
    trained_SingleSegPara.Trained_TrainFeature_Cell = Trained_TrainFeature_Cell;
    trained_SingleSegPara.Trained_TestFeature_Cell = Trained_TestFeature_Cell;
    trained_SingleSegPara.DataTrainLabel_BlockCell = DataTrainLabel_BlockCell;
    trained_SingleSegPara.DataTestLabel_BlockCell = DataTestLabel_BlockCell;
    trained_SingleSegPara.sortedSingleCFTSScoreIdx = sortedSingleCFTSScoreIdx;
    trained_SingleSegPara.sortedSingleCFTSAcc = sortedSingleCFTSAcc;
    trained_SingleSegPara.selSortedIdx = selSortedIdx;
    trained_SingleSegPara.trainedWcsp = trainedWcsp;
    trained_SingleSegPara.Acc = Acc;

end

