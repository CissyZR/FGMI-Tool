function keepTimeStepName = getValidTimeStepsByRange(startIdx, endIdx, Fs, timeStepName)
% getValidTimeStepsByRange
% 根据起止采样点与 Fs，按 0.5 s 对齐后，从 timeStepName 中选出应保留的时间窗
% 输入:
%   startIdx     : 起始点（采样点）
%   endIdx       : 终止点（采样点）
%   Fs           : 采样率（如 250）
%   timeStepName : 时间窗口名称 cell，如 {'0-0.5s'; '0.5-1.0s'; ...}
% 输出:
%   keepTimeStepName : 满足条件的时间窗口名称 cell

    % -------- 参数校验 --------
    validateattributes(startIdx, {'numeric'},{'scalar','real','>=',0});
    validateattributes(endIdx,   {'numeric'},{'scalar','real','>=',startIdx});
    validateattributes(Fs,       {'numeric'},{'scalar','real','>',0});
    validateattributes(timeStepName, {'cell'},{'vector','nonempty'});

    % -------- 名称解析为起止时间（秒）--------
    nStep = numel(timeStepName);
    timeRange = zeros(nStep, 2);
    for i = 1:nStep
        s = erase(timeStepName{i}, 's');
        parts = split(s, '-');
        timeRange(i,1) = str2double(parts{1});
        timeRange(i,2) = str2double(parts{2});
    end

    % -------- 将采样点换算为秒，并按 0.5 s 对齐 --------
    startSec = startIdx / Fs;
    endSec   = endIdx   / Fs;

    step = 0.5; % 对齐步长（秒）
    alignedStart = floor(startSec/step) * step; % 向下对齐
    alignedEnd   = ceil(endSec/step)   * step; % 向上对齐

    % -------- 选择起止均落入 [alignedStart, alignedEnd] 的窗口 --------
    keepIdx = (timeRange(:,1) >= alignedStart) & (timeRange(:,2) <= alignedEnd);
    keepTimeStepName = timeStepName(keepIdx);
end
