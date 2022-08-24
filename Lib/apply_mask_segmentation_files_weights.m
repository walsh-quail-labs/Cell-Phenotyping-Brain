function apply_mask_segmentation_files_weights(filePath,metalJMFtablePath,outcomeJMFPath,additional_dilation_table)


metalListTable = readtable(metalJMFtablePath);
lookUpTable = metalListTable.Metal;
topKS = metalListTable.Presence;
[~,fileName,~] = fileparts(filePath);
[~,Pano] = imreadText(filePath);
allHeaders = Pano.textdata;
mkdir(fullfile(outcomeJMFPath,fileName));


MetalDil = additional_dilation_table.Metal;
DilationLevel = additional_dilation_table.Dilation;

for lt = 1 : length(lookUpTable) 
    
    metal_query = lookUpTable{lt};
    ind_itr = find(contains(allHeaders,metal_query));
    result = imreadTextChannel(Pano,ind_itr);                
    topK = topKS(lt);
    resultIm= single(im2double(result));
    finalMask=computeMaskWithWeights(resultIm,topK);
    if size(MetalDil,1) > 0
        if contains(MetalDil,metal_query)
            itr_t = contains(MetalDil,metal_query);
            finalMask = imdilate(finalMask,strel('disk',DilationLevel(itr_t)));
        end
    end

    result = im2double(result);
    if ~isempty(find(finalMask==1, 1))
        result = result/mean(result(finalMask==1));
    end
    origIpath = fullfile(outcomeJMFPath,fileName,strcat(metal_query,'_1.png'));
    maskIpath = fullfile(outcomeJMFPath,fileName,strcat(metal_query,'_2.png'));
    imwrite(result,origIpath);
    imwrite(finalMask,maskIpath);
    
end


end