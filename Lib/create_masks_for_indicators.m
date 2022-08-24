function create_masks_for_indicators(panoFilePath,adjustingIndicators,metalListIndicator)
[~,Pano] = imreadText(panoFilePath);
allHeaders = Pano.textdata;

for aI = 1 : length(adjustingIndicators)
    
    
    cur_ind = adjustingIndicators{aI};
    metal_query = '';
    thresh_query = 50;
    for i = 1 : length(metalListIndicator)
        if strcmp(metalListIndicator{i},cur_ind)
            metal_query = metalListMetals{i};
            thresh_query = metalListThresh(i);
        end
    end
    
    cur_ind
    
    
    ind_itr = find(contains(allHeaders,strcat(cur_ind,'(')));
    curIndMatrix = imreadTextChannelRaw(Pano,ind_itr);
    
    lR = importdata(fullfile('MetalColumnVectors',strcat(metal_query,'.mat')));
    [n,bins]=histcounts(lR,100);
    nOfBins = 100;
    
    
    thresh = exp(bins(nOfBins-thresh_query));
    BW = curIndMatrix;
    BW(curIndMatrix<thresh) = 0;
    BW(curIndMatrix>=thresh) = 1;
    BW = ~bwareaopen(~BW,5);
    BW = bwareaopen(BW,5);
    
    mkdir(fullfile('JMFNew',fileName))
    origIpath = fullfile('JMFNew',fileName,strcat(cur_ind,'_1.png'));
    maskIpath = fullfile('JMFNew',fileName,strcat(cur_ind,'_2.png'));
    imwrite(imreadTextChannel(Pano,ind_itr),origIpath);
    imwrite(BW,maskIpath);
end