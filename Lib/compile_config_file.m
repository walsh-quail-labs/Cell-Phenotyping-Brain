function [input_pano_folder,input_cell_segmentation_folder,input_keyPatientID,group_PatientID,output_folder,IndicatorsListPath,nuc_csv_source_folder,ring_csv_source_folder,rule_table_location]=compile_config_file(config_file_path)


configTable = readtable(config_file_path);
params = configTable.PARAM;
values = configTable.VALUE;

input_pano_folder = '';
for i = 1 : length(params)
    if strcmp(params{i},'input_pano_folder')
        input_pano_folder = values{i};
    end
end


input_cell_segmentation_folder = '';
for i = 1 : length(params)
    if strcmp(params{i},'input_cell_segmentation_folder')
        input_cell_segmentation_folder = values{i};
    end
end



input_keyPatientID = '';
for i = 1 : length(params)
    if strcmp(params{i},'input_keyPatientID')
        input_keyPatientID = values{i};
    end
end



group_PatientID = '';
for i = 1 : length(params)
    if strcmp(params{i},'group_PatientID')
        group_PatientID = values{i};
    end
end


output_folder = '';
for i = 1 : length(params)
    if strcmp(params{i},'output_folder')
        output_folder = values{i};
    end
end


IndicatorsListPath = '';
for i = 1 : length(params)
    if strcmp(params{i},'IndicatorsListPath')
        IndicatorsListPath = values{i};
    end
end


nuc_csv_source_folder = '';
for i = 1 : length(params)
    if strcmp(params{i},'nuc_csv_source_folder')
        nuc_csv_source_folder = values{i};
    end
end

ring_csv_source_folder = '';
for i = 1 : length(params)
    if strcmp(params{i},'ring_csv_source_folder')
        ring_csv_source_folder = values{i};
    end
end

counter = 1;
for i = 1 : length(params)
    if contains(params{i},'rule_table_location_')
        cohortName = extractBetween(params{i},length('rule_table_location_')+1,length(params{i}));
        rule_table_location{counter,1} = cohortName{1};
        rule_table_location{counter,2} = values{i};
        counter = counter+1;
    end
end


end