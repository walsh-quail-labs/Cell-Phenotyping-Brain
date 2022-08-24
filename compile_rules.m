clear all;
clc;
addpath(genpath('Lib'))
addpath(genpath('ConfigFiles'))
config_file_path = 'config_template.xlsx';
additional_dilation_table_path = 'additional_dilation.xlsx';
metalJMFtablePath = fullfile('ConfigFiles','metal_indicator_JMF_kmeans.xlsx');
outcomeJMFPath = 'JMFPath';

cIMatOuputFolder = 'presence_matrices';
output_figure_folder = 'output_folder';
allCellTypesAddress = fullfile('ConfigFiles','allCellTypesRGB.xlsx');
ring_rad = 3;
percentile = 0.995;
run_step_JMF = 1;


allLabelsTable = readtable(allCellTypesAddress);
allLabels = allLabelsTable.CellTypes;
R = allLabelsTable.R;
G = allLabelsTable.G;
B = allLabelsTable.B;
type_colors = [R,G,B]/255;


run_celltype_assignment = 1;

[~,configFileName,~] = fileparts(config_file_path);

config_path = fullfile('ConfigFiles',config_file_path);

[IndicatorsList,nuc_csv_source_folder,ring_csv_source_folder,rule_table_location,nOfGroups,groupPatientIDTableData,headerGroupPatientID,fileNameColumn,imageIDColumn,regIndices_files,pano_files,IndicatorsListPath,input_pano_folder,input_cell_segmentation_folder,output_folder]=read_tables_list_files(config_path);


middleString = [];
files =[];

if run_step_JMF == 0
    metalListThreshVals= obtain_thresh_vals(metalJMFtablePath);
end


if run_step_JMF==1 && ~exist(outcomeJMFPath,'dir')
    mkdir(outcomeJMFPath);
end

for indexFile = 1 %: length(pano_files)

    close all;


    panoFilePath = pano_files(indexFile).name;
    [folderPath,scanName,~]=fileparts(panoFilePath);

    T = find(contains(fileNameColumn,scanName));
    if ~isempty(T)

        pathStructure = extractBetween(panoFilePath,length(input_pano_folder)+1,length(panoFilePath));
        pathStructure = pathStructure{1};
        [folderName,fileName,~]=fileparts(pathStructure);
        cellTypeToSavePath = fullfile(output_folder,'MATData',folderName,strcat(fileName,'.mat'));

        folderStructure = extractBetween(folderPath,length(input_pano_folder)+1,length(folderPath));
        folderPathReg = fullfile(input_cell_segmentation_folder,folderStructure,scanName);
        folderPathReg = folderPathReg{1};
        regIndPath = fullfile(folderPathReg,'allRegionIndices.mat');
        ringIndPath = fullfile(folderPathReg,'allRingIndices.mat');
        nucleiFilePath = fullfile(folderPathReg,'nuclei_multiscale.mat');
        found_group = '';
        for gI = 1:nOfGroups
            curGr = groupPatientIDTableData(:,gI);
            for rowItr = 1 : length(curGr)
                if strcmp(curGr{rowItr},imageIDColumn{T})
                    groupName = headerGroupPatientID{gI};
                    groupName = extractBetween(groupName,length('Group_')+1,length(groupName));
                    groupName = groupName{1};

                    for ri = 1 : size(rule_table_location,1)
                        if strcmp(rule_table_location{ri,1},groupName)
                            rule_table_location_for_this_group = rule_table_location{ri,2};
                            found_group = groupName;
                        end
                    end
                end
            end
        end

        if (~exist(cellTypeToSavePath,'file') && run_step_JMF==1 ) || (run_celltype_assignment==0 && run_step_JMF==1)
            additional_dilation_table = readtable(additional_dilation_table_path);
            disp('mask segmentation')
            apply_mask_segmentation_files_weights(panoFilePath,metalJMFtablePath,outcomeJMFPath,additional_dilation_table);
        end
        if run_celltype_assignment


            allCellTypes =main_cell_type_assignment_v3(rule_table_location_for_this_group,outcomeJMFPath,scanName,regIndPath,ringIndPath);
            cellTypeToSavePath = save_celltypes(allCellTypes,panoFilePath,input_pano_folder,input_cell_segmentation_folder,output_folder);
            create_figure_here(cellTypeToSavePath,output_folder,input_cell_segmentation_folder,output_figure_folder,allLabels,type_colors);
        end
    else
        fprintf('The program is not producing a celltype for file: [%s]\n',scanName);
    end


end


