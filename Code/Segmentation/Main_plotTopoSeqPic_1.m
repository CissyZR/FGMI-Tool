clear;

load('CFTMap_All_BCIMyExp_3s_100PData.mat', 'saveSelChCell');

selChCell = saveSelChCell{1,1,1};

nPicPerCol = 5;

figure;
hSubPlot_SP = tight_subplot(numel(selChCell)/nPicPerCol, nPicPerCol, [0.035 0.005], [0.08 0.08], [0.08 0.08]);

for iPic = 1:numel(selChCell)
    axes(hSubPlot_SP(iPic)); 
%     subplot(numel(selChCell)/nPicPerCol, nPicPerCol, iPic);
    plotData = rand(1,59);
    topoplotEEG(plotData,'channel_locations_59ch.txt','electrodes','on','onlymark', selChCell{iPic});
    title([num2str(iPic)]);
%     xlabel([num2str(iPic)]);
    
end
