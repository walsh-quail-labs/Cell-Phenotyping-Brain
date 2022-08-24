function create_masks(filePath,metalJMFtablePath,outcomeJMFPath,metalListThreshVals)

metalListTable = readtable(metalJMFtablePath);
metalListMetals = metalListTable.Metal;
[~,fileName,~] = fileparts(filePath);
[~,Pano] = imreadText(filePath);
allHeaders = Pano.textdata;
mkdir(fullfile(outcomeJMFPath,fileName));

for aI = 1 : length(metalListMetals)        
    metal_query = metalListMetals{aI};
    ind_itr = find(contains(allHeaders,metal_query));
    curIndMatrix = imreadTextChannelRaw(Pano,ind_itr);
    curIndMatrix = medfilt2(curIndMatrix,[3,3]);
    thresh = metalListThreshVals(aI);
    BW = curIndMatrix;
    BW(curIndMatrix<thresh) = 0;
    BW(curIndMatrix>=thresh) = 1;
    BW = ~bwareaopen(~BW,5);
    BW = bwareaopen(BW,5);        
    origIpath = fullfile(outcomeJMFPath,fileName,strcat(metal_query,'_1.png'));
    maskIpath = fullfile(outcomeJMFPath,fileName,strcat(metal_query,'_2.png'));
    imwrite(imreadTextChannel(Pano,ind_itr),origIpath);
    imwrite(BW,maskIpath);
end

end

