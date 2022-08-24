function result = findWherePathAdderssesAresStored(allPaths,regPaths)

if iscell(regPaths)
    query = regPaths{1};
else
    query = regPaths;
end
[~,query,~] = fileparts(fileparts(query));
for i = 1 : length(allPaths)
    
    curPaths = allPaths{i};
    
    if iscell(curPaths)
        for j = 1 : length(curPaths)
            curpathJ = curPaths{j};
            [~,fileName,~] = fileparts(curpathJ);
            if strcmp(fileName,query)
                result = i;
            end
        end
    else
        [~,fileName,~] = fileparts(curPaths{1});
        if strcmp(fileName,query)
            result = i;
        end
    end
    
end

end