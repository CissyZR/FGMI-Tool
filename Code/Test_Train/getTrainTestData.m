function [DataTrain, DataTrainLabel, DataTest, DataTestLabel] = getTrainTestData(DATA, LABEL, iBlock, opt)

    testBlockFlag = false(1,numel(DATA));
    testBlockFlag(iBlock) = true;
    testBlockData = DATA(testBlockFlag);
    testBlockLabel = LABEL(testBlockFlag);
    trainBlockData = DATA(~testBlockFlag);
    trainBlockLabel = LABEL(~testBlockFlag);

    % Gather Training Dataset
    DataTrain = [];
    DataTrainLabel = [];
    for i = 1:numel(trainBlockData)
        DataTrain = cat(1,DataTrain,trainBlockData{i});
        DataTrainLabel = cat(1,DataTrainLabel,trainBlockLabel{i});
    end
    data = permute(DataTrain,[3 2 1]);
    sizeData = size(data);
    data = data(:,:);
    curData = data;

    % if opt.isWaveletDec250Hz
    %     curData = zeros(size(data));
    %     tic;
    %     parfor j = 1:size(data,2)
    %         curData(:,j) = wvdec(data(:,j)')';
    %     end
    %     disp(['Training Data DWT: ' num2str(toc) 's']);
    % end

    DataTrain = reshape(curData,sizeData);
    DataTrain = permute(DataTrain,[3 2 1]);
        

    % Gather Testing Dataset
    DataTest = [];
    DataTestLabel = [];
    for i = 1:numel(testBlockData)
        DataTest = cat(1,DataTest,testBlockData{i});
        DataTestLabel = cat(1,DataTestLabel,testBlockLabel{i});
    end        
    data = permute(DataTest,[3 2 1]);
    sizeData = size(data);
    data = data(:,:);
    curData = data;

    % if opt.isWaveletDec250Hz
    %     curData = zeros(size(data));
    %     tic;
    %     parfor j = 1:size(data,2)
    %         curData(:,j) = wvdec(data(:,j)')';
    %     end
    %     disp(['Testing Data DWT: ' num2str(toc) 's']);
    % end

    DataTest = reshape(curData,sizeData);
    DataTest = permute(DataTest,[3 2 1]);
    

end

