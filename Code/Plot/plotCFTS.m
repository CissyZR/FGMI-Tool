function saveDir = plotCFTS(opt)
       
    load(fullfile(opt.Path.visualpath, 'model.mat'), 'trained_AlignSegPara');
    % load(fullfile(fileparts(fileparts(fileparts(opt.Path.visualpath))), 'param.mat'));
    
    [CFTSInfoCell, ~, ~, ~] = getCFTSInfo(opt);
    CFTSInfo_VecCell = CFTSInfoCell(:);
    nCFTS = numel(CFTSInfo_VecCell);
    opt.CFTSInfo_Cell = CFTSInfoCell;

    if opt.numch == 22
        chfile = 'channel_locations_22ch.txt';
    elseif opt.numch == 59
        chfile = 'channel_locations_59ch.txt';
    elseif opt.numch == 62
        chfile = 'channel_locations_62ch.txt';
    else
        error('Can not find this channel number ', opt.numch);
    end

%============================获取saveCFTMap==============================

    freqbandMin = min(opt.FreqRngMat, [], 'all');
    freqbandMax = max(opt.FreqRngMat, [], 'all');
    timebandMin = min(opt.TimeRngMat, [], 'all');
    timebandMax = max(opt.TimeRngMat, [], 'all');
    chGroupMax = numel(opt.SelChCell);
    
    tfMap = zeros(freqbandMax, timebandMax);
    tfCountMap = zeros(freqbandMax, timebandMax);
    ctMap = zeros(chGroupMax, timebandMax);
    ctCountMap = zeros(chGroupMax, timebandMax);
    cfMap = zeros(freqbandMax, chGroupMax);
    cfCountMap = zeros(freqbandMax, chGroupMax);
    cftMap = zeros(chGroupMax, freqbandMax, timebandMax);
    cftCountMap = zeros(chGroupMax, freqbandMax, timebandMax);
    curSortedAcc = trained_AlignSegPara.plotData.sortedAcc;
    curSortedAccIdx = trained_AlignSegPara.plotData.sortedIdx;
    % count是用来技术，计算算了几次的
    % xxMap即是准确率的总和数据
    for iCFTS = 1:nCFTS
        curCFTS = curSortedAccIdx(iCFTS);
        curCFTSInfo = CFTSInfo_VecCell{curCFTS};
        selFBand = curCFTSInfo.FBand(1):curCFTSInfo.FBand(2);
        selTBand = curCFTSInfo.TBand(1):curCFTSInfo.TBand(2);
        selChGroup = find(cellfun(@(x) (isequal(x,curCFTSInfo.SelCh)), opt.SelChCell));
        tfMap(selFBand,selTBand) = tfMap(selFBand,selTBand) + curSortedAcc(iCFTS);
        tfCountMap(selFBand,selTBand) = tfCountMap(selFBand,selTBand) + 1;
        ctMap(selChGroup,selTBand) = ctMap(selChGroup,selTBand) + curSortedAcc(iCFTS);
        ctCountMap(selChGroup,selTBand) = ctCountMap(selChGroup,selTBand) + 1;
        cfMap(selFBand, selChGroup) = cfMap(selFBand, selChGroup) + curSortedAcc(iCFTS);
        cfCountMap(selFBand, selChGroup) = cfCountMap(selFBand, selChGroup) + 1;
        cftMap(selChGroup,selFBand,selTBand) = cftMap(selChGroup,selFBand,selTBand) + curSortedAcc(iCFTS);
        cftCountMap(selChGroup,selFBand,selTBand) = cftCountMap(selChGroup,selFBand,selTBand) + 1;
    end
    saveCFTMap = cftMap./cftCountMap;
    saveSelChCell = opt.SelChCell;
    
timeStepName_all = {'0-0.5s'; '0.5-1.0s';'1.0-1.5s';'1.5-2.0s';'2.0-2.5s';'2.5-3.0s';'3.0-3.5s';'3.5-4.0s'};
timeStepName = getValidTimeStepsByRange(timebandMin, timebandMax, opt.Fs, timeStepName_all);
nPic = numel(timeStepName);

freqStepName = {'Theta','Alpha','Low-Beta','High-Beta','Gamma'};
freqStepMat_all = {[4 8]; [8 12]; [12 20]; [20 30]; [30 38]};
freqStepMat = adjustFreqStepMat(freqStepMat_all, freqbandMin, freqbandMax);

% ==============================ElectrodeMap=====================================

fig = figure('Visible','off');
hSubPlot_SP = tight_subplot(numel(freqStepMat),nPic, [0.005 0.005], [0.08 0.08], [0.2 0.1]);
fontSize = 8;

nFreqBand = numel(freqStepMat);
rawCTMap = cell(1, nFreqBand);
rawCTMap_cnt = cell(1, nFreqBand);
rawCTplotMap = cell(1, nFreqBand);
rawCTplotMap_TSMean_ChExpand = cell(nFreqBand, nPic);
for iFreqBand = 1:nFreqBand
    rawCTMap{iFreqBand} = zeros(size(saveCFTMap,1), size(saveCFTMap,3));
    rawCTMap_cnt{iFreqBand} = rawCTMap{iFreqBand};
    for iPic = 1:nPic
        rawCTplotMap_TSMean_ChExpand{iFreqBand, iPic} = struct;
    end
end
        
curFoldData = saveCFTMap;
curFoldChInfo = saveSelChCell;
for iFreq = 1:nFreqBand
    plotCTMap = squeeze(sum(curFoldData(:,freqStepMat{iFreq}(1):freqStepMat{iFreq}(2),:), 2, 'omitnan'));
    for iChGroupIdx = 1:size(plotCTMap,1)
        curGroupCTMap = plotCTMap(iChGroupIdx,:);
        rawCTMap{iFreq}(iChGroupIdx,:) = rawCTMap{iFreq}(iChGroupIdx,:) + curGroupCTMap;
        rawCTMap_cnt{iFreq}(iChGroupIdx,:) = rawCTMap_cnt{iFreq}(iChGroupIdx,:) + 1;
    end    
end

catVal = [];
for iFreqBand = 1:nFreqBand    
    rawCTplotMap{iFreqBand} = rawCTMap{iFreqBand};  %./rawCTMap_cnt{iFreqBand};    
    % Fold to Time-step
    rawCTplotMap_TS{iFreqBand} = reshape(rawCTplotMap{iFreqBand}, size(rawCTplotMap{iFreqBand},1), [], nPic);    % TS: Time Suppress
    rawCTplotMap_TSMean{iFreqBand} = squeeze(sum(rawCTplotMap_TS{iFreqBand}, 2, 'omitnan'));    
    for iSelPic = 1:size(rawCTplotMap_TSMean{iFreqBand},2)
        [maxChGroupValue, maxChGroupId] = max(rawCTplotMap_TSMean{iFreqBand}(:,iSelPic));
%                 maxChGroupValue = log10(maxChGroupValue);
        rawCTplotMap_TSMean_ChExpand{iFreqBand,iSelPic}.channelIndex = curFoldChInfo{maxChGroupId};
        rawCTplotMap_TSMean_ChExpand{iFreqBand,iSelPic}.channelValue = repmat(maxChGroupValue, [1 numel(curFoldChInfo{maxChGroupId})]);
        catVal = cat(2, catVal, rawCTplotMap_TSMean_ChExpand{iFreqBand,iSelPic}.channelValue);
    end   
end      
        
% Plot electrode map        
for iFreqBand = 1:nFreqBand
    for iPic = 1:nPic
        axes(hSubPlot_SP(nPic*(iFreqBand-1)+iPic)); 
        plotTopoData = cat(1,rawCTplotMap_TSMean_ChExpand{iFreqBand,iPic}.channelIndex,...
                             rawCTplotMap_TSMean_ChExpand{iFreqBand,iPic}.channelValue);
        if ~sum(plotTopoData(1,:))
            plotTopoData = [];
        end
        gMin = min(catVal(:), [], 'omitnan');
        gMax = max(catVal(:), [], 'omitnan');
        mycolormap = colormap('bone');
        mycolormap = flipud(mycolormap);
        topoplotEEG_mark(rand(1,59), chfile,'colormap',mycolormap,'electrodes','on','maplimits',[gMin gMax],'onlymark', plotTopoData);
        if iFreqBand == 1
            title(timeStepName{iPic});
        end
        set(gca, 'FontSize', fontSize);
    end
    
end

for iFreqBand = 1:nFreqBand
    stepUnit = 0.17;
    annotation('textbox',[0.1 0.77-(iFreqBand-1)*0.17 0.1 0.1],'String',freqStepName{iFreqBand},'FitBoxToText','on', 'LineStyle', 'none','HorizontalAlignment','right','FontSize',fontSize);

end

colorbar('Location','manual','Position',[0.912 0.09 0.02 0.82],'FontSize',fontSize);

saveDir = fileparts(mfilename('fullpath'));
saveas(fig, fullfile(saveDir, 'Electrode_map.png'));
close(fig);
%================================TopoMap===============================
fig2 = figure('Visible','off');
hSubPlot_SP = tight_subplot(numel(freqStepMat),nPic, [0.005 0.005], [0.08 0.08], [0.2 0.1]);
fontSize = 8;

nFreqBand = numel(freqStepMat);
rawCTMap = cell(1, nFreqBand);
rawCTMap_cnt = cell(1, nFreqBand);
rawCTplotMap = cell(1, nFreqBand);
for iFreqBand = 1:nFreqBand
    rawCTMap{iFreqBand} = zeros(opt.numch, size(saveCFTMap,3));
    rawCTMap_cnt{iFreqBand} = rawCTMap{iFreqBand};
end
     
curFoldData = saveCFTMap;
curFoldChInfo = saveSelChCell;

for iFreq = 1:nFreqBand
    plotCTMap = squeeze(mean(curFoldData(:,freqStepMat{iFreq}(1):freqStepMat{iFreq}(2),:), 2, 'omitnan'));
    for iChGroupIdx = 1:size(plotCTMap,1)
        curGroupCTMap = plotCTMap(iChGroupIdx,:);
        rawCTMap{iFreq}(curFoldChInfo{iChGroupIdx},:) = rawCTMap{iFreq}(curFoldChInfo{iChGroupIdx},:) + repmat(curGroupCTMap, [numel(curFoldChInfo{iChGroupIdx}) 1]);
        rawCTMap_cnt{iFreq}(curFoldChInfo{iChGroupIdx},:) = rawCTMap_cnt{iFreq}(curFoldChInfo{iChGroupIdx},:) + 1;
    end    
end 

for iFreqBand = 1:nFreqBand
    rawCTplotMap{iFreqBand} = rawCTMap{iFreqBand}./rawCTMap_cnt{iFreqBand};
    
    % Fold to Time-step
    rawCTplotMap_TS{iFreqBand} = reshape(rawCTplotMap{iFreqBand}, size(rawCTplotMap{iFreqBand},1), [], nPic);    % TS: Time Suppress
    rawCTplotMap_TSMean{iFreqBand} = squeeze(mean(rawCTplotMap_TS{iFreqBand}, 2));
    gMin(iFreqBand) = min(rawCTplotMap_TSMean{iFreqBand}, [], 'all');
    gMax(iFreqBand) = max(rawCTplotMap_TSMean{iFreqBand}, [], 'all');            
    
    % Plot Map
    for iPic = 1:nPic
        axes(hSubPlot_SP(nPic*(iFreqBand-1)+iPic)); 
        topoplotEEG(rawCTplotMap_TSMean{iFreqBand}(:,iPic)',chfile,'electrodes','off','maplimits', [min(gMin) max(gMax)]);
        if iFreqBand == 1
            title(timeStepName{iPic});
        end
        set(gca, 'FontSize', fontSize);
    end
end
for iFreqBand = 1:nFreqBand
    stepUnit = 0.17;
    annotation('textbox',[0.1 0.77-(iFreqBand-1)*0.17 0.1 0.1],'String',freqStepName{iFreqBand},'FitBoxToText','on', 'LineStyle', 'none','HorizontalAlignment','right','FontSize',fontSize);

end
colorbar('Location','manual','Position',[0.92 0.09 0.02 0.82],'FontSize',fontSize);

saveas(fig2, fullfile(saveDir, 'Topo_map.png'));
close(fig2);
end