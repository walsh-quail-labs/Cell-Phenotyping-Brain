function compute_presence_matrix_with_overlay(outcomeJMFPath,metalList,scanName,regIndPath,ringIndPath,nucleiPath)


JMFPath = fullfile(outcomeJMFPath,scanName);
nOfInds = length(metalList);
allRegInds = importdata(regIndPath);
data = importdata(nucleiPath);
Boundaries = data.Boundaries;
imsize = size(data.nucleiImage);
nOfCells = length(allRegInds);


for j = 1 : nOfInds
    curMask = imread(fullfile(JMFPath,strcat(metalList{j},'_2.png')));
    curImage = imread(fullfile(JMFPath,strcat(metalList{j},'_1.png')));
    mask_cell = fullfile(JMFPath,strcat(metalList{j},'_cells_2.png'));
    image_cell = fullfile(JMFPath,strcat(metalList{j},'_cells_1.png'));
    curImage = im2double(curImage);
    if ~isempty(find(curMask==1, 1))
        curImage = curImage/mean(curImage(curMask==1));
    end
    figure;
    imshow(curMask)
    hold on;
    for i =1: nOfCells
        curBoundary = Boundaries{i};
%         size(curBoundary)
        [X,Y] = ind2sub(imsize,curBoundary);
        plot(Y,X,'r.');
    end
    export_fig(mask_cell);
    close all;
    figure;
    imshow(curImage)
    hold on;
    for i =1: nOfCells
        curBoundary = Boundaries{i};
        [X,Y] = ind2sub(imsize,curBoundary);
        plot(Y,X,'r.');
    end
    export_fig(image_cell);
end

