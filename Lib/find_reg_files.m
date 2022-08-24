function [allRegIndsPath,finalScanName] = find_reg_files(fileNamesForThisGroup,indexFile,regIndices_files)

if ~iscellstr(fileNamesForThisGroup{indexFile})
    for j = 1:length(regIndices_files)
        fullFilePath = regIndices_files(j).name;
        [folderPath,~,~]=fileparts(fullFilePath);
        endout=regexp(folderPath,filesep,'split');
        scanName = endout{end};
        if strcmp(scanName,fileNamesForThisGroup{indexFile}) ==1
            allRegIndsPath = fullFilePath;
        end
    end
    [~,finalScanName,~]=fileparts(fileparts(allRegIndsPath));
else
    curCell = fileNamesForThisGroup{indexFile};
    finalScanName = '';
    allRegIndsPath = cell(length(curCell),1);
    for tt = 1 : length(curCell)
        queryStr = curCell{tt};
        for j = 1:length(regIndices_files)
            fullFilePath = regIndices_files(j).name;
            [folderPath,~,~]=fileparts(fullFilePath);
            endout=regexp(folderPath,filesep,'split');
            scanName = endout{end};
            if strcmp(scanName,queryStr) ==1
                allRegIndsPath{tt} = fullFilePath;
            end
        end
        [~,cur_scanName,~]=fileparts(fileparts(allRegIndsPath{tt}));
        if tt > 1
            if length(cur_scanName) < length(finalScanName)
                finalScanName = cur_scanName;
            end
        else
            finalScanName = cur_scanName;
        end
    end
    
end

end


