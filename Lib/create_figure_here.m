function create_figure_here(cellTypeFilePath,input_cell_type_folder,input_cell_segmentation_folder,output_figure_folder,allLabels,type_colors)


pathStructure = extractBetween(cellTypeFilePath,length(input_cell_type_folder)+1,length(cellTypeFilePath));

pathStructure = pathStructure{1};

[folderName,fileName,~]=fileparts(pathStructure);
k = strfind(folderName,'MATData');

if k+ 7 >= length(folderName)
    folderName = '';
else
    folderName = extractBetween(folderName,k+8,length(folderName));
    folderName = folderName{1};
end
%         if strcmp(fileName,'20191121_BrM_8Others_2_ROI_13-1158-C2_3')
%     fullfile(input_cell_segmentation_folder,folderName,fileName,'nuclei_multiscale.mat')
    fullfile(input_cell_segmentation_folder,folderName,fileName,'nuclei_multiscale.mat')
    nucData = importdata(fullfile(input_cell_segmentation_folder,folderName,fileName,'nuclei_multiscale.mat'));
    cellTypes = importdata(cellTypeFilePath);
    Boundaries = nucData.Boundaries;
    nucleiImage = nucData.nucleiImage;


    pdfcellTypeToSavePath = fullfile(output_figure_folder,'PDF',folderName,strcat(fileName,'.pdf'));
    if ~exist(fullfile(output_figure_folder,'PDF',folderName), 'dir')
        mkdir(fullfile(output_figure_folder,'PDF',folderName));
    end

    figure;
    imshow(zeros(size(nucleiImage)));
    hold on;
    nOfCells = length(cellTypes);
    for i = 1 : nOfCells
        curB = Boundaries{i};
        if size(curB,1) > 3
            [X,Y] = ind2sub(size(nucleiImage),curB);
            typeCell = cellTypes{i};

            resInd = find(strcmp(allLabels, typeCell));
            if isempty(resInd)
                resInd = size(type_colors,1);
            end
            fill(Y,X,type_colors(resInd,:));

        end
    end
    export_fig(pdfcellTypeToSavePath);

end