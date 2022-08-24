function [nuc_pathAddressArray,reg_pathAddressArray] = create_cell_intensity_indicator(fileNamesForThisGroup,indexFile,pano_files,regIndices_files,nuc_csv_files,ring_csv_files,nuc_csv_source_folder,ring_csv_source_folder,IndicatorsList,ring_rad)


if ~iscellstr(fileNamesForThisGroup{indexFile})
    for j = 1:length(pano_files)
        fullFilePath = pano_files(j).name;
        [~,scanName,~]=fileparts(fullFilePath);
        if strcmp(scanName,fileNamesForThisGroup{indexFile}) ==1
            panoFilePath = fullFilePath;
        end
    end
else
    curCell = fileNamesForThisGroup{indexFile};
    panoFilePath = cell(length(curCell),1);
    for tt = 1 : length(curCell)
        queryStr = curCell{tt};
        for j = 1:length(pano_files)
            fullFilePath = pano_files(j).name;
            [~,scanName,~]=fileparts(fullFilePath);
            if strcmp(scanName,queryStr) ==1
                panoFilePath{tt} = fullFilePath;
            end
        end
    end
end




%%% find all region indices file addresses
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

%%% find csv (.csv) file addresses
CombinedFlag = 0;
nuc_csvFilePathSourceFound = 0;
if ~iscellstr(fileNamesForThisGroup{indexFile})
    for j = 1:length(nuc_csv_files)
        fullFilePath = nuc_csv_files(j).name;
        [~,scanName,~]=fileparts(fullFilePath);
        if strcmp(scanName,fileNamesForThisGroup{indexFile}) ==1
            nuc_csvFilePathSourceFound = 1;
        end
    end
else
    CombinedFlag = 1;
    curCell = fileNamesForThisGroup{indexFile};
    for tt = 1 : length(curCell)
        queryStr = curCell{tt};
        for j = 1:length(nuc_csv_files)
            fullFilePath = nuc_csv_files(j).name;
            [~,scanName,~]=fileparts(fullFilePath);
            if strcmp(scanName,queryStr) ==1
                nuc_csvFilePathSourceFound = 1;
            end
        end
    end
end


ring_csvFilePathSourceFound = 0;
if ~iscellstr(fileNamesForThisGroup{indexFile})
    for j = 1:length(ring_csv_files)
        fullFilePath = ring_csv_files(j).name;
        [~,scanName,~]=fileparts(fullFilePath);
        if strcmp(scanName,fileNamesForThisGroup{indexFile}) ==1
            ring_csvFilePathSourceFound = 1;
        end
    end
else
    curCell = fileNamesForThisGroup{indexFile};
    for tt = 1 : length(curCell)
        queryStr = curCell{tt};
        for j = 1:length(ring_csv_files)
            fullFilePath = ring_csv_files(j).name;
            [~,scanName,~]=fileparts(fullFilePath);
            if strcmp(scanName,queryStr) ==1
                ring_csvFilePathSourceFound = 1;
            end
        end
    end
end


ring_mode= 0;
nuc_pathAddressArray=save_csv_intensity_matrix_mat_filepaths(nuc_csv_source_folder,finalScanName,nuc_csvFilePathSourceFound,CombinedFlag,panoFilePath,allRegIndsPath,IndicatorsList,ring_mode,ring_rad);
ring_mode= 1;
reg_pathAddressArray=save_csv_intensity_matrix_mat_filepaths(ring_csv_source_folder,finalScanName,ring_csvFilePathSourceFound,CombinedFlag,panoFilePath,allRegIndsPath,IndicatorsList,ring_mode,ring_rad);




end