function [foldData, foldLabel, indices] = makeBalancedKFolds(TrainData, TrainLabel, K, seed)
% TrainData : [Ntrial × Nch × Nt]
% TrainLabel: [Ntrial × 1]
% K         : 折数
% seed      : (可选) 随机种子，便于复现实验
% 输出:
%   foldData{K}  : 每折数据 (trial × ch × t)
%   foldLabel{K} : 每折标签 (trial × 1)
%   indices      : 每个 trial 对应的折号 (1..K)

    if nargin < 4, seed = 42; end
    rng(seed);

    N  = size(TrainData, 1);
    yl = TrainLabel(:);
    classes = unique(yl);
    C = numel(classes);

    % 先做一次“分层”分配（尽量均衡各类在各折的分布）
    indices = zeros(N,1);
    for ci = 1:C
        idx_c = find(yl == classes(ci));
        idx_c = idx_c(randperm(numel(idx_c)));           % 打乱
        Nc    = numel(idx_c);
        base  = ceil(Nc / K);                             % 每折该类目标样本数
        % 先均匀切分
        ptr = 1;
        for k = 1:K
            take = min(base, Nc - (ptr-1));
            if take > 0
                pick = idx_c(ptr:ptr+take-1);
                indices(pick) = k;
                ptr = ptr + take;
            end
        end
        % 若有未分配（极少见），随机分配到折
        left = find(indices(idx_c)==0);
        if ~isempty(left)
            indices(idx_c(left)) = randi(K, numel(left), 1);
        end
    end

    % 统计每折每类当前数量，并按“每类 ceil(Nc/K)”目标进行补齐(有放回抽样)
    foldData  = cell(K,1);
    foldLabel = cell(K,1);
    % 预计算每类全局索引（当某折该类为0时，从全局兜底采样）
    classGlobalIdx = cell(C,1);
    classTargetPerFold = zeros(C,1);
    for ci = 1:C
        idx_c = find(yl == classes(ci));
        classGlobalIdx{ci} = idx_c;
        classTargetPerFold(ci) = ceil(numel(idx_c) / K);
    end

    for k = 1:K
        idx_fold = find(indices == k);
        % 先拿到当前折所有 trial
        Xk = TrainData(idx_fold,:,:);
        yk = yl(idx_fold);
        % 按类检查并补齐
        for ci = 1:C
            idx_fold_c = idx_fold(yk == classes(ci));      % 本折该类的全局 trial 索引
            cur = numel(idx_fold_c);
            need = classTargetPerFold(ci) - cur;
            if need > 0
                % 优先从“本折该类已有样本”中有放回抽样补齐；
                % 若本折该类为0，则从“全局该类”兜底抽样补齐
                if cur > 0
                    src = idx_fold_c;
                else
                    src = classGlobalIdx{ci};
                end
                addIdx = src(randi(numel(src), need, 1));   % 有放回
                % 追加到折
                Xk = cat(1, Xk, TrainData(addIdx,:,:));
                yk = [yk; yl(addIdx)];
            end
        end
        % 可选：打乱本折顺序，避免补齐样本集中在末尾
        ord = randperm(size(Xk,1));
        foldData{k}  = Xk(ord,:,:);
        foldLabel{k} = yk(ord);
    end
end
