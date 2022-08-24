function [IndicatorsList,nuc_csv_source_folder,ring_csv_source_folder,rule_table_location,nOfGroups,groupPatientIDTableData,headerGroupPatientID,fileNameColumn,imageIDColumn,regIndices_files,pano_files,IndicatorsListPath,input_pano_folder,input_cell_segmentation_folder,output_folder]=read_tables_list_files(config_path)

[input_pano_folder,input_cell_segmentation_folder,input_keyPatientID,group_PatientID,output_folder,IndicatorsListPath,nuc_csv_source_folder,ring_csv_source_folder,rule_table_location]=compile_config_file(config_path);
mkdir(output_folder);
IndicatorsListTable = readtable(IndicatorsListPath);
IndicatorsList = IndicatorsListTable.Variables; % the same as keep up table




fprintf('The code is reading from pano data folder %s\n',input_pano_folder);
fprintf('The code is reading from cell segmentation data folder %s\n',input_cell_segmentation_folder);
fprintf('The code is reading key patient id file from %s\n',input_keyPatientID);
fprintf('The code is reading group patient ids file from %s\n',group_PatientID);

groupPatientIDTable = readtable(group_PatientID);
nOfGroups = width(groupPatientIDTable);
groupPatientIDTableData = groupPatientIDTable.Variables;


inputKeyPatientIDTable = readtable(input_keyPatientID);

headerKeyTable = inputKeyPatientIDTable.Properties.VariableNames;
headerGroupPatientID = groupPatientIDTable.Properties.VariableNames;

columnIndexFileName = contains(headerKeyTable,'FileName');
columnIndexImageID = contains(headerKeyTable,'UniqueImageID');
inputKeyPatientIDData = inputKeyPatientIDTable.Variables;
fileNameColumn = inputKeyPatientIDData(:,columnIndexFileName);
imageIDColumn = inputKeyPatientIDData(:,columnIndexImageID);




middleString = [];
regIndices_files =[];
for i = 1 : 10
    regIndices_files = [regIndices_files;rdir(fullfile(input_cell_segmentation_folder,middleString,'allRegionIndices.mat'))];
    middleString = fullfile(middleString,'*');
end


middleString = [];
pano_files =[];
for i = 1 : 10
    pano_files = [pano_files;rdir(fullfile(input_pano_folder,middleString,'*.txt'))];
    middleString = fullfile(middleString,'*');
end

for i = 1 : length(pano_files)
    [~,fileNameQ,~]=fileparts(pano_files(i).name);
    
    foundQuery = 0;
    for j = 1 : length(regIndices_files)
        [~,fileNameR,~]=fileparts(fileparts(regIndices_files(j).name));        
        if strcmp(fileNameQ,fileNameR) 
            foundQuery = 1;
        end
    end
    if foundQuery==0
        [folderPath,fileName,~]=fileparts(pano_files(i).name);
        
        folderStructure = extractBetween(folderPath,length(input_pano_folder)+1,length(folderPath));
        folderPathNuc = fullfile(input_cell_segmentation_folder,folderStructure,fileName);
        folderPathNuc = folderPathNuc{1};
        nucleiFilePath = fullfile(folderPathNuc,'nuclei_multiscale.mat');
        data = importdata(nucleiFilePath);
        Boundaries = data.Boundaries;
        
        I = data.nucleiImage;
        allRegInds = cell(length(Boundaries),1);
        for k = 1 : length(Boundaries)
            curB = Boundaries{k};

            allRegInds{k} = compute_area_of_a_cell_from_indices(curB,size(I));

        end
        save(fullfile(folderPathNuc,'allRegionIndices.mat'),'allRegInds');


        allRingIndsPath = fullfile(folderPathNuc,'allRingIndices.mat');
        nOfCells = length(allRegInds);
        
        allRingInds = cell(nOfCells,1);
        for iii = 1 : nOfCells
            ringImage = zeros(size(I));
            ringImage(allRegInds{iii}) = 1;
            ringImageDil = imdilate(ringImage,strel('disk',3));
            ringImage = ringImageDil-ringImage;
            allRingInds{iii} = find(ringImage==1);
        end
        save(allRingIndsPath,'allRingInds');
    end

    



end



end