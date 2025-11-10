function [RngMat, nBand] = GetTimeBands(Fs, stPoint, wndWidth, endPoint, RngMat)


% RngMat = [];
wndWidth = wndWidth*Fs;
for iband = 1:length(wndWidth)
    noverlap = round(wndWidth(iband)/2);
    RngMat = addRngMat(stPoint, wndWidth(iband), endPoint, noverlap, RngMat);
end

if ~isempty(RngMat)
    R4 = round(RngMat, 6);                         % 根据需要调整精度
    [~, ia] = unique(R4, 'rows', 'stable');        % 'stable' 保留先来顺序
    RngMat  = RngMat(ia, :);
end


nBand = size(RngMat,1);

end


