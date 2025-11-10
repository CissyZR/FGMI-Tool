function freqStepMat_adj = adjustFreqStepMat(freqStepMat, freqbandMin, freqbandMax)
% adjustFreqStepMat
% 根据实际数据频率范围修正freqStepMat，防止索引越界
%
% 输入:
%   freqStepMat   : 原始频段定义 (cell)，如 {[4 8]; [8 12]; ...}
%   freqbandMin   : 实际频率索引最小值，例如1或0
%   freqbandMax   : 实际频率索引最大值，例如36
%
% 输出:
%   freqStepMat_adj : 修正后的freqStepMat (cell)

    nBands = numel(freqStepMat);
    freqStepMat_adj = cell(size(freqStepMat));
    
    for i = 1:nBands
        curRange = freqStepMat{i};
        
        % 若原始定义超出范围，则自动裁剪
        startVal = max(freqbandMin, curRange(1));
        endVal   = min(freqbandMax, curRange(2));
        
        % 如果该频段已无效（end<start），跳过或压缩为单点
        if endVal < startVal
            % 可选策略1：跳过该频段
            % freqStepMat_adj{i} = [];
            
            % 可选策略2：压缩为单点频段（保证不为空）
            endVal = startVal;
        end
        
        freqStepMat_adj{i} = [startVal endVal];
    end
end


