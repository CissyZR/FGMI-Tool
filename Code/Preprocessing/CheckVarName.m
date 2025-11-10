function CheckVarName(app, filepath, varNames)
    % if ischar(varNames)
    %     varNames = {varNames};
    % elseif isstring(varNames)
    %     varNames = cellstr(varNames);
    % elseif ~iscellstr(varNames)
    %     error('BadInput:VarNames', 'varNames 必须是 char/string/cellstr。');
    % end
    % varNames: 目标目录需要有的变量名称
    fileInfo = {whos('-file', filepath).name};    % 加载目录现有的名称

    
    hasData = ismember(varNames, fileInfo);
    if all(hasData)
        return
    end
    LackName = varNames(~hasData);
    uialert(app.UIFigure, ...
            sprintf('文件 "%s" 中缺少以下变量:\n%s', filepath, strjoin(LackName, ', ')), ...
            '变量缺失', ...
            'Icon', 'warning');
    % error('MissingVars:MATFile', ...
    %       '文件 %s 中缺少以下变量: %s', ...
    %       filepath, strjoin(LackName,','));
       

end

