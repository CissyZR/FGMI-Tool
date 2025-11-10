function PlotFreqBands(ax, RngMat, nBand)
% 校验 ax 是否是有效(UI)Axes
    if ~isvalid(ax) || ~isgraphics(ax,'axes')
        error('PlotFreqBands:InvalidAxes','ax 不是有效的坐标轴句柄');
    end 
   
    cla(ax)
    for iBand = 1:nBand
        plot(ax, [RngMat(iBand,1) RngMat(iBand,2)], [iBand iBand], ...
             '-o', 'Color', 'black', 'LineWidth', 1, 'MarkerSize', 3);
        
        hold (ax,'on');
        
    end
    
    hold (ax,'off');
    xlabel(ax, 'Frequency(Hz)');
    ylabel(ax, 'Number of Frequency Band');
    % ax.FontSize = 10;
    axis(ax, [-inf inf 0 nBand+1]);
    box (ax,'on');



