function GetChGroups(GroupsMat_File, chlocation_File)
% 生成Goups图片以便后面更新加载
GroupsMat = load(GroupsMat_File).savedChCell;

if numel(GroupsMat) > 5
    nPicPerCol = 5;
else
    nPicPerCol = numel(GroupsMat);
end

fig = figure('Visible','off','Units','normalized');  % 不显示窗口
% fig = figure;
hSubPlot_SP = tight_subplot(numel(GroupsMat)/nPicPerCol, nPicPerCol, [0.05 0.005], [0.08 0.08], [0.08 0.08]);
% hSubPlot_SP = tiledlayout(5, 2, 'Padding','none', 'TileSpacing','none');
% hSubPlot_SP = tight_subplot(numel(GroupsMat)/nPicPerCol, nPicPerCol,  [0.0001 0.0001], [0.001 0.001], [0.001 0.001]);
fid = fopen(chlocation_File);
A = fscanf(fid,'%d %f %f %s',[7 256]);
fclose(fid);
for iPic = 1:numel(GroupsMat)
    % ax = hSubPlot_SP(iPic);

    
    % axes(ax);
    % cla(ax);

    subplot(numel(GroupsMat)/nPicPerCol, nPicPerCol, iPic);
    plotData = rand(1,size(A,2));
    topoplotEEG(plotData, chlocation_File, 'electrodes','on','onlymark', GroupsMat{iPic});
    title([num2str(iPic)]);
%     xlabel([num2str(iPic)]);
    
end

% set(hSubPlot_SP, 'Box', 'off', 'XColor', 'none', 'YColor', 'none');
exportgraphics(fig, 'D:\Pro\SoftwareX\MI_Decoder_App\Segmentation\topo_map_new.png', 'Resolution', 200);
% exportgraphics(fig, 'D:\Pro\SoftwareX\MI_Decoder_App\Segmentation\topo_map_new_test.png', 'Resolution', 300);

% close(fig);  % 关闭隐藏的 figure，释放资源
end
