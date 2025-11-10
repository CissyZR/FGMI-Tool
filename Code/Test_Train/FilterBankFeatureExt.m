function [LinkVarMatTrain, LinkVarMatTest, Wcsp] = FilterBankFeatureExt(DataTrain, DataTest, DataTrainLabel, DataTestLabel, opt, WcspIn)
if nargin > 5
    opt.CSP_Config.Wcsp = WcspIn;
end

CSP_Config = opt.CSP_Config;
nClass = opt.nClass;

if isempty(CSP_Config.Wcsp)
    %% 将各个类别分出来
    DataTrainClass = cell(1,nClass);
    for iClass = 1:nClass
        DataTrainClass{iClass} = DataTrain(DataTrainLabel == iClass, :, :);
    %     DataTrainLabelClass{iClass} = DataTrainLabel(DataTrainLabel == iClass);
    end

    %% 分组进行CSP
    % v = [1;2;3;4];
    v = (1:nClass)';
    C = nchoosek(v, 2);
    Wcsp = cell(1, size(C, 1));
    for iChoose = 1:size(C, 1)
        Choose = C(iChoose, :);
        switch CSP_Config.Mode
            case 'div-CSP'
                Wcsp{iChoose} = div_csp(DataTrainClass{Choose(1)}, DataTrainClass{Choose(2)}, CSP_Config.nCSP);
            case 'CSP'
                Wcsp{iChoose} = csp(DataTrainClass{Choose(1)}, DataTrainClass{Choose(2)}, CSP_Config.nCSP);
            otherwise
                Wcsp{iChoose} = div_csp(DataTrainClass{Choose(1)}, DataTrainClass{Choose(2)}, CSP_Config.nCSP);
        end
    end
else
    Wcsp = CSP_Config.Wcsp;
end
%% 用CSP矩阵W进行滤波

LinkVarMatTrain = [];
for iChoose = 1:numel(Wcsp)
    dataVar = zeros(size(DataTrain,1), 2*CSP_Config.nCSP);
    for iTrail = 1:size(DataTrain, 1)
        data = Wcsp{iChoose}'*reshape(DataTrain(iTrail, :, :), size(DataTrain,2), size(DataTrain,3));
        data = -log(var(data, 0, 2)'./sum(var(data, 0, 2)));
        dataVar(iTrail, :) = data;
    end
    LinkVarMatTrain = cat(2, LinkVarMatTrain, dataVar);
end
LinkVarMatTrain = LinkVarMatTrain';

LinkVarMatTest = [];
if ~isempty(DataTest)
    for iChoose = 1:numel(Wcsp)
        dataVar = zeros(size(DataTest,1), 2*CSP_Config.nCSP);
        for iTrail = 1:size(DataTest, 1)
 
            data = Wcsp{iChoose}'*reshape(DataTest(iTrail, :, :), size(DataTest,2), size(DataTest,3));
            data = -log(var(data, 0, 2)'./sum(var(data, 0, 2)));
            dataVar(iTrail, :) = data;
        end
        LinkVarMatTest = cat(2, LinkVarMatTest, dataVar);
    end
    LinkVarMatTest = LinkVarMatTest';
end
