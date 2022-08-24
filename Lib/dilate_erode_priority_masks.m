function dilate_erode_priority_masks(filePath,metalJMFtablePath,outcomeJMFPath,additional_dilation_table,priority_table,groupName)


metalListTable = readtable(metalJMFtablePath);
lookUpTable = metalListTable.Metal;
low_pr = priority_table.Low_Priority;
high_pr = priority_table.High_Priority;
kind_pr = priority_table.Kind;
group_pr = priority_table.Group;
[~,fileName,~] = fileparts(filePath);
mkdir(fullfile(outcomeJMFPath,fileName));


MetalDil = additional_dilation_table.Metal;
DilationLevel = additional_dilation_table.Dilation;

for lt = 1 : length(lookUpTable) 
    
    metal_query = lookUpTable{lt};
    finalMask = imbinarize(im2double(imread(fullfile(outcomeJMFPath,fileName,strcat(metal_query,'_2.png')))));
    if size(MetalDil,1) > 0
        if contains(MetalDil,metal_query)
            itr_t = contains(MetalDil,metal_query);
            finalMask = imdilate(finalMask,strel('disk',DilationLevel(itr_t)));
            imwrite(finalMask,maskIpath);
        end
    end
    
end


for i = 1 : length(low_pr)
    if strcmp(kind_pr{i},'Strong') && strcmp(group_pr{i},groupName) 
        low_im = imbinarize(im2double(imread(fullfile(outcomeJMFPath,fileName,strcat(low_pr{i},'_2.png')))));
        high_im = imbinarize(im2double(imread(fullfile(outcomeJMFPath,fileName,strcat(high_pr{i},'_2.png')))));
        low_im = im2double(imbinarize(im2double(low_im))) - imdilate(im2double(and(low_im,imdilate(high_im,strel('disk',3)))),strel('disk',2));
        low_im(low_im<0) = 0;
        low_im = bwareaopen(low_im,40);
        high_im = imdilate(high_im,strel('disk',1));
        imwrite(low_im,fullfile(outcomeJMFPath,fileName,strcat(low_pr{i},'_2.png')));
        imwrite(high_im,fullfile(outcomeJMFPath,fileName,strcat(high_pr{i},'_2.png')));
    end
    if strcmp(kind_pr{i},'Weak') && strcmp(group_pr{i},groupName) 
        
        low_im = imbinarize(im2double(imread(fullfile(outcomeJMFPath,fileName,strcat(low_pr{i},'_2.png')))));
        high_im = imbinarize(im2double(imread(fullfile(outcomeJMFPath,fileName,strcat(high_pr{i},'_2.png')))));
        %        high_im = bwareaopen(high_im,100);
        high_im = bwareaopen(high_im,50);
        low_im = im2double(imbinarize(im2double(low_im))) - im2double(and(low_im,imdilate(high_im,strel('disk',3))));
        low_im(low_im<0) = 0;
        imwrite(low_im,fullfile(outcomeJMFPath,fileName,strcat(low_pr{i},'_2.png')));
        imwrite(high_im,fullfile(outcomeJMFPath,fileName,strcat(high_pr{i},'_2.png')));
    end
    if strcmp(kind_pr{i},'SuperWeak') && strcmp(group_pr{i},groupName) 
        low_im = imbinarize(im2double(imread(fullfile(outcomeJMFPath,fileName,strcat(low_pr{i},'_2.png')))));
        high_im = imbinarize(im2double(imread(fullfile(outcomeJMFPath,fileName,strcat(high_pr{i},'_2.png')))));
        low_im = im2double(imbinarize(im2double(low_im))) - im2double(and(low_im,high_im));
        low_im(low_im<0) = 0;
        imwrite(low_im,fullfile(outcomeJMFPath,fileName,strcat(low_pr{i},'_2.png')));
    end
end



end