function Visual_Plot(opt)
clear;

% DatasetA = load(fullfile(pwd, 'BCI_2008_SFT_Pics', '3s', 'saveData', 'CFTMap_All.mat'));
% DatasetB = load(fullfile(pwd, 'saveData', 'CFTMap_All.mat'));
DatasetB = load('D:\Pro\SoftwareX\MI_Decoder_App\Plot\SFTMap\CFTMap_All.mat');

iS = 1;
ParadigmName = {'LHEvRHE';'LHvRH';'LEvRE'};

nPic = 6;
timeStepName = {'0-0.5s'; '0.5-1.0s';'1.0-1.5s';'1.5-2.0s';'2.0-2.5s';'2.5-3.0s'};

figure;
hSubPlot_SP = tight_subplot(numel(ParadigmName),nPic, [0.05 0.01], [0.08 0.08], [0.2 0.08]);

freqbandMin = 4;
freqbandMax = 38;

saveCFTMap = DatasetB.saveCFTMap;
saveSelChCell = DatasetB.saveSelChCell;
for iP = 1:size(saveCFTMap,2)
    rawCTMap = zeros(59, size(saveCFTMap{1,1,1},3));
    rawCTMap_cnt = rawCTMap;
    for iFold = 1:size(saveCFTMap,3)
        curFoldData = saveCFTMap{iS, iP, iFold};
        curFoldChInfo = saveSelChCell{iS, iP, iFold};
        plotCTMap = squeeze(mean(curFoldData, 2, 'omitnan'));
        for iChGroupIdx = 1:size(plotCTMap,1)
            curGroupCTMap = plotCTMap(iChGroupIdx,:);
            rawCTMap(curFoldChInfo{iChGroupIdx},:) = rawCTMap(curFoldChInfo{iChGroupIdx},:) + repmat(curGroupCTMap, [numel(curFoldChInfo{iChGroupIdx}) 1]);
            rawCTMap_cnt(curFoldChInfo{iChGroupIdx},:) = rawCTMap_cnt(curFoldChInfo{iChGroupIdx},:) + 1;
            
        end
        
    end
    rawCTplotMap = rawCTMap./rawCTMap_cnt;
    
    % Fold to Time-step
    rawCTplotMap_TS = reshape(rawCTplotMap, size(rawCTplotMap,1), [], nPic);
    rawCTplotMap_TSMean = squeeze(mean(rawCTplotMap_TS, 2));
    gMin = min(rawCTplotMap_TSMean, [], 'all');
    gMax = max(rawCTplotMap_TSMean, [], 'all');
    
    for iPic = 1:nPic
        axes(hSubPlot_SP(nPic*(iP-1)+iPic)); 
%         subplot(numel(ParadigmName),nPic,nPic*(iP-1)+iPic);
        topoplotEEG(rawCTplotMap_TSMean(:,iPic)','channel_locations_59ch.txt','electrodes','off','maplimits', [gMin gMax]);
        if iP == 1
            title(timeStepName{iPic});
        end
        set(gca, 'FontSize', 10);
    end
    
    
end

% annotation('textbox',[0.05 3/7 0.1 0.1],'String','LvR','FitBoxToText','on', 'LineStyle', 'none');

