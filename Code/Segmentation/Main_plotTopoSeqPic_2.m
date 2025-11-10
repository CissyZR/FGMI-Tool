
load('CFTMap_All_BCI2008_3s_100PData.mat', 'saveSelChCell');

selChCell = saveSelChCell{1,1,6};

nPicPerCol = 5;

figure;
hSubPlot_SP = tight_subplot(numel(selChCell)/nPicPerCol, nPicPerCol, [0.05 0.005], [0.08 0.08], [0.08 0.08]);

for iPic = 1:numel(selChCell)
    ax = hSubPlot_SP(iPic);
    cla(ax);
    axes(ax);
%     subplot(numel(selChCell)/nPicPerCol, nPicPerCol, iPic);
    plotData = rand(1,22);
    topoplotEEG(plotData,'channel_locations_22ch.txt','electrodes','on','onlymark', selChCell{iPic});
    title([num2str(iPic)]);
%     xlabel([num2str(iPic)]);
    
end
