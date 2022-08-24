function cellTypeToSavePath = save_celltypes(allCellTypes,panoFilePath,input_pano_folder,input_cell_segmentation_folder,output_folder)

cellTypes = allCellTypes(:,size(allCellTypes,2));
pathStructure = extractBetween(panoFilePath,length(input_pano_folder)+1,length(panoFilePath));
pathStructure = pathStructure{1};
[folderName,fileName,~]=fileparts(pathStructure);
cellTypeToSavePath = fullfile(output_folder,'MATData',folderName,strcat(fileName,'.mat'));
if ~exist(fullfile(output_folder,'MATData',folderName), 'dir')
    mkdir(fullfile(output_folder,'MATData',folderName));
end
save(cellTypeToSavePath,'cellTypes');

end