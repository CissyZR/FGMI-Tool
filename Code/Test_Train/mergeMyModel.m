function trainModel = mergeMyModel(opt)

%% Global Settings

Path.modelGroup_Train{1} = fullfile(opt.Path.pathpwd, ['modelGroup_' num2str(opt.featureExtractionMethod)]);

Path_output.outputpath_supervise = fullfile(opt.Path.pathpwd, 'outputModels');

CheckIfDirExist(Path_output);

% opt.nSelUClassifier = 2;
% opt.nSelSClassifier = opt.KFold-1;

% selPerson = 1;

%% Setting Train
% clearvars -except Path opt noTrainModel;

tic;
% for iSelPerson = 1:numel(selPerson)  % numel(classifierPersonDir)
    % iPerson = selPerson(iSelPerson);
    trainModel = cell(1, numel(Path.modelGroup_Train));
    for iPath = 1:numel(Path.modelGroup_Train)
        curPath = Path.modelGroup_Train{iPath};
        classifierDir = dir(fullfile(curPath, 'Classifier_*'));
        for iClassifier = 1:numel(classifierDir)
            curClassifierPath = fullfile(classifierDir(iClassifier).folder, classifierDir(iClassifier).name);
            classifierPersonDir = dir(fullfile(curClassifierPath, 'model*'));
            
            curClassifierPersonPath = fullfile(curClassifierPath, ['model.mat']);
            load(curClassifierPersonPath, 'trained_AlignSegPara');
            
            curTrainModel = trained_AlignSegPara.trainModel;
            curModifyTrainModel.Classifier = curTrainModel.Classifier(1:opt.nSelSClassifier,:);
            curModifyTrainModel.SelTFSInfo = curTrainModel.SelTFSInfo(1:opt.nSelSClassifier);
            
            trainModel{iPath}.ClassifierCell{iClassifier} = curModifyTrainModel;
            
            
            disp(['iPath: ' num2str(iPath) '. iClassifier: ' num2str(iClassifier) '.']);
        end
        trainModel{iPath}.Wcsp = trained_AlignSegPara.Wcsp;
        trainModel{iPath}.TFInfo = curTrainModel.TFInfo;
    end
    allPersonModel{1} = trainModel;
% end
toc;

%% Compact
% for iPerson = 1:numel(classifierPersonDir)
    tic;
    curTrainModel = allPersonModel{1};
    for iTM = 1:numel(curTrainModel)
%         curTrainSubModel = curTrainModel(iTM);
        nCFTS = numel(curTrainModel{iTM}.TFInfo);
%         discardIdx = true(1,nCFTS);
        catSelTFSInfo_Vec = [];
        for iClassifier = 1:numel(curTrainModel{iTM}.ClassifierCell)
            curSelTFSInfo_Vec = cell2mat(curTrainModel{iTM}.ClassifierCell{iClassifier}.SelTFSInfo);
            catSelTFSInfo_Vec = cat(2, catSelTFSInfo_Vec, curSelTFSInfo_Vec);
            
        end
        unique_SelTFSInfo = unique(catSelTFSInfo_Vec);
%         discardIdx(unique_SelTFSInfo) = false;
        Wcsp_shape = size(curTrainModel{iTM}.Wcsp);
        TFInfo_shape = size(curTrainModel{iTM}.TFInfo);
        curTrainModel{iTM}.Wcsp = curTrainModel{iTM}.Wcsp(unique_SelTFSInfo,:);
        curTrainModel{iTM}.TFInfo = curTrainModel{iTM}.TFInfo(unique_SelTFSInfo);
        curTrainModel{iTM}.restructInfo.Wcsp_shape = Wcsp_shape;
        curTrainModel{iTM}.restructInfo.TFInfo_shape = TFInfo_shape;
        curTrainModel{iTM}.restructInfo.useIdx = unique_SelTFSInfo;
        
    end
    trainModel = curTrainModel;
%     trainModel = cat(2, trainModel, noTrainModel);
    save(fullfile(Path_output.outputpath_supervise, ['model_final.mat']), 'trainModel');
    
    toc;
% end

