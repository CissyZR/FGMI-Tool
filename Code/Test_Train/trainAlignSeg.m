function trained_AlignSegPara = trainAlignSeg(trained_SingleSegPara, opt)
%% Unpack Struct Data
    Trained_TrainFeature_Cell = trained_SingleSegPara.Trained_TrainFeature_Cell;
    Trained_TestFeature_Cell = trained_SingleSegPara.Trained_TestFeature_Cell;
    DataTrainLabel_BlockCell = trained_SingleSegPara.DataTrainLabel_BlockCell;
    DataTestLabel_BlockCell = trained_SingleSegPara.DataTestLabel_BlockCell;
    sortedSingleCFTSScoreIdx = trained_SingleSegPara.sortedSingleCFTSScoreIdx;
    sortedSingleCFTSAcc = trained_SingleSegPara.sortedSingleCFTSAcc;
    selSortedIdx = trained_SingleSegPara.selSortedIdx;
    trainedWcsp = trained_SingleSegPara.trainedWcsp;
    Acc = trained_SingleSegPara.Acc;

    CFTSInfo_VecCell = opt.CFTSInfo_Cell(:);
    if opt.cntFeatureStep > 6
        opt.cntFeatureStep = 6;
    end
%% Train Align Feature
    nBlock = numel(DataTrainLabel_BlockCell);
    nFeature = size(Trained_TrainFeature_Cell,1);
    cntFeature = 1:opt.cntFeatureStep:nFeature;
    multiFeatureModel_Cell = cell(numel(cntFeature), nBlock);
    alignFeatureMeanAcc = zeros(nBlock, numel(cntFeature));
    alignFeatureSepAcc = zeros(nBlock, numel(opt.Lambda), numel(cntFeature));
    for iBlock = 1:nBlock
        curTrainFeatureMat = Trained_TrainFeature_Cell(:,iBlock);     % nCFTSx1 cell, Trialx4 double
        curTestFeatureMat = Trained_TestFeature_Cell(:, iBlock);

        tmpFeatureMeanAcc = zeros(1,numel(cntFeature));
        tmpFeatureSepAcc = zeros(numel(opt.Lambda),numel(cntFeature));
        multiFeatureModel_tmpCell = cell(numel(cntFeature),1);
        for cnt = 1:numel(cntFeature)   % parfor
            iFeature = cntFeature(cnt);
            % 排序
            curSelTrainFeatureMat = curTrainFeatureMat(selSortedIdx);    % 200x1 cell, Trialx4 double
            curSelTestFeatureMat = curTestFeatureMat(selSortedIdx);
            curCFTSInfo = CFTSInfo_VecCell(selSortedIdx);             % 200x1 cell, 1x1 struct
            % 训练
            multiFeatureModel = GetMultiFeatureParaImagery(curSelTrainFeatureMat,...
                                                    DataTrainLabel_BlockCell{iBlock}, iFeature, opt);
            % 预测
            predictLabel = PredictMultiFeatureSingleTrail(multiFeatureModel,...
                                                    curSelTestFeatureMat, DataTestLabel_BlockCell{iBlock},...
                                                    iFeature, opt);
            % 获取平均结果和全部结果
            [tmpFeatureMeanAcc(cnt), tmpFeatureSepAcc(:,cnt)] = getResult(DataTestLabel_BlockCell{iBlock}, double(predictLabel), opt);                               
            % 保存全部模型
            
            multiFeatureModel_tmpCell{cnt} = multiFeatureModel;

            disp(['Ranked CFTS N: ' num2str(cnt) '/' num2str(numel(cntFeature)) ' | Block: ' num2str(iBlock)]);

        end
        multiFeatureModel_Cell(:,iBlock) = multiFeatureModel_tmpCell;
        alignFeatureMeanAcc(iBlock,:) = tmpFeatureMeanAcc;
        alignFeatureSepAcc(iBlock,:,:) = tmpFeatureSepAcc;  % 3 x 11 x 1013
        
    end
    meanAlignFeatureMeanAcc = mean(alignFeatureMeanAcc);        % 获得平均交叉验证准确率
    if size(alignFeatureSepAcc,2) == 1
        meanAlignFeatureSepAcc = squeeze(mean(alignFeatureSepAcc))';          % 获得未平均交叉验证准确率, 11 x 1013
    else
        meanAlignFeatureSepAcc = squeeze(mean(alignFeatureSepAcc));          % 获得未平均交叉验证准确率, 11 x 1013
    end
    %     meanAlignFeatureScore = mean(alignFeatureScore);
    [sortMeanAlignFeatureAcc, idxMeanAlignFeatureAcc] = sort(meanAlignFeatureMeanAcc, 'descend');   % 排序平均交叉验证准确率
    
    meanAlignFeatureN = cntFeature(idxMeanAlignFeatureAcc(1:opt.nSelSortBand)); % 
    selSegBandCell = cell(1, numel(meanAlignFeatureN));
    for iSelCTFS = 1:numel(meanAlignFeatureN)
        selSegBandCell{iSelCTFS} = sortedSingleCFTSScoreIdx(1:meanAlignFeatureN(iSelCTFS));
    end
    selAlignSortedIdx = idxMeanAlignFeatureAcc(1:opt.nSelSortBand);
    [maxSepAcc, maxSepAccIdx] = max(meanAlignFeatureSepAcc(:,selAlignSortedIdx));  % 排序未平均交叉验证准确率
    
    trainedAlignModel = multiFeatureModel_Cell(selAlignSortedIdx,:);
    if opt.nCalValAcc > length(maxSepAcc)
        opt.nCalValAcc = length(maxSepAcc);
    end

    if (opt.classifyMethod == "Lasso" )|| (opt.classifyMethod == "Ridge") 
        for iSelBlock = 1:size(trainedAlignModel,2)
            parfor iSelCTFS = 1:size(trainedAlignModel,1)
                trainedAlignModel{iSelCTFS, iSelBlock} = ...
                    selectModels(trainedAlignModel{iSelCTFS, iSelBlock},maxSepAccIdx(iSelCTFS));
            end
        end
        valMeanAcc = mean(maxSepAcc(1:opt.nCalValAcc));  % 
    else
        valMeanAcc = mean(sortMeanAlignFeatureAcc(1:opt.nCalValAcc));  % 
    end

    trained_AlignSegPara.plotData.sortMeanAlignFeatureAcc = sortMeanAlignFeatureAcc;
    trained_AlignSegPara.plotData.sortedAcc = sortedSingleCFTSAcc;
    trained_AlignSegPara.plotData.sortedIdx = sortedSingleCFTSScoreIdx;
    trained_AlignSegPara.plotData.MeanAlignFeatureMeanAcc = meanAlignFeatureMeanAcc;
    
    trained_AlignSegPara.trainModel.Classifier = trainedAlignModel;
    trained_AlignSegPara.trainModel.SelTFSInfo = selSegBandCell;
    trained_AlignSegPara.trainModel.TFInfo = CFTSInfo_VecCell;
    trained_AlignSegPara.Wcsp = trainedWcsp;   % 原始iSegBand排序的Wcsp
    trained_AlignSegPara.valMeanAcc = valMeanAcc;

    
    
end

