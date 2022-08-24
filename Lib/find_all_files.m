function [fileNamesForThisGroup,nuc_csv_files,ring_csv_files] = find_all_files(indexGroup,nuc_csv_source_folder,ring_csv_source_folder,groupPatientIDTableData,imageIDColumn,fileNameColumn)
middleString = [];
nuc_csv_files =[];

for i = 1 : 100
    nuc_csv_files = [nuc_csv_files;rdir(fullfile(nuc_csv_source_folder,middleString,'*.csv'))];
    middleString = fullfile(middleString,'*');
end
middleString = [];
ring_csv_files =[];
for i = 1 : 100
    ring_csv_files = [ring_csv_files;rdir(fullfile(ring_csv_source_folder,middleString,'*.csv'))];
    middleString = fullfile(middleString,'*');
end

close all;
cur_group_keys = groupPatientIDTableData(:,indexGroup);
cur_group_keys = cur_group_keys(~cellfun(@isempty, cur_group_keys));
fileNamesForThisGroup = cell(size(cur_group_keys));

for i = 1 : length(cur_group_keys)
    cur_key = cur_group_keys{i};
    rowIndex = find(contains(imageIDColumn,cur_key));
    
    
    if length(rowIndex)==1
        fileNamesForThisGroup{i} = fileNameColumn{rowIndex};
    else
        
        curCell = cell(length(rowIndex),1);
        for tt = 1 : length(rowIndex)
            curCell{tt} = fileNameColumn{rowIndex(tt)};
        end
        fileNamesForThisGroup{i} = curCell;
    end
    
end
end