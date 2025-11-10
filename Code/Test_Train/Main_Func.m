function Main_Func(DataAllPat, LabelAllPat, opt)
opt.Lambda = logspace(-5,-0.3,30);
opt.AlignTrainFunc = getAlignTrainFuncHandle(opt); % 将所需的函数func挂载
% opt.ParallelFlag = 1;
% opt.nSelSortBand = 50;  %50
% opt.nCalValAcc = 10;
% opt.cntFeatureStep = 42;

% Check Output Result Path
opt.Path.outputWcspPath = fullfile(opt.Path.pathpwd, ['modelGroup_' num2str(opt.featureExtractionMethod)]);
opt.Path.outputModelPath = fullfile(opt.Path.outputWcspPath, ['Classifier_' num2str(opt.classifyMethod)]);
CheckIfDirExist(opt.Path);

% Common configuration
opt.nClass = numel(unique(LabelAllPat{1}{1}));

% CSP configuration
opt.CSP_Config.Wcsp = [];

% Get CFTS information
[CFTSInfoCell, ~, ~, ~] = getCFTSInfo(opt);
opt.CFTSInfo_Cell = CFTSInfoCell;
%

% Train Single CFTS
% if ~isempty(dir(fullfile(opt.Path.outputWcspPath, ['trained_SingleSegPara.mat'])))
%     load(fullfile(opt.Path.outputWcspPath, ['trained_SingleSegPara.mat']), 'trained_SingleSegPara');
% else
trained_SingleSegPara = trainSingleSeg(DataAllPat{1}, LabelAllPat{1}, opt);
save(fullfile(opt.Path.outputWcspPath, ['trained_SingleSegPara.mat']), 'trained_SingleSegPara', '-v7.3');
% end

%% Train Align CFTS
trained_AlignSegPara = trainAlignSeg(trained_SingleSegPara, opt);
valMeanAcc = trained_AlignSegPara.valMeanAcc;
save(fullfile(opt.Path.outputModelPath, ['model.mat']), 'trained_AlignSegPara', 'valMeanAcc', '-v7.3');


valMeanAccMat = valMeanAcc;

%% Summary
finalMeanAcc = mean(valMeanAccMat);
T = 3; Q = opt.nClass; P = valMeanAccMat; ITR = (60./T).*(log2(Q)+P.*log2(P)+(1-P).*log2((1-P)./(Q-1)));
save(fullfile(opt.Path.outputModelPath, ['accInfo.mat']), 'valMeanAccMat', 'finalMeanAcc', 'ITR');

end

%% Support Function
function funcHd = getAlignTrainFuncHandle(opt)
    switch opt.classifyMethod
        case 'SVM'
            funcHd = @trainAlignLinear_multiclassSVM_TernaryComplete;
        case "Ridge"
            funcHd = @trainAlignLinear_multiclassRidge_TernaryComplete;
        case "Lasso"
            funcHd = @trainAlignLinear_multiclassLasso_TernaryComplete;       
        otherwise
            error('No Such Option');
    end

end


    