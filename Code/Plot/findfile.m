function outfile = findfile(path)
    baseDir = fileparts(fileparts(path)); 

    % 搜索所有以 "modelGroup_" 开头的文件夹
    d = dir(fullfile(baseDir, 'modelGroup_*'));
    d = d([d.isdir]);  % 只保留文件夹
    if isempty(d)
        error('Can not find modelGroup_ *', baseDir);
    end

    % 取第一个匹配项（如需全部可循环）
    modelGroupFolder = fullfile(baseDir, d(1).name);
    o = dir(fullfile(modelGroupFolder, 'Classifier_*'));
    outfile = fullfile(modelGroupFolder, o(1).name);

end