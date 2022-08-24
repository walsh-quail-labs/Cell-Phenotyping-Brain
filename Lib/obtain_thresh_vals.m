function metalListThreshVals= obtain_thresh_vals(metalJMFtablePath)
metalListTable = readtable(metalJMFtablePath);

metalListMetals = metalListTable.Metal;
metalListThresh = metalListTable.Presence;
metalListThreshVals = zeros(length(metalListMetals),1);
for aI = 1 : length(metalListMetals)        
    metal_query = metalListMetals{aI};
    thresh_query = metalListThresh(aI);
    lR = importdata(fullfile('MetalColumnVectors',strcat(metal_query,'.mat')));
    [~,bins]=histcounts(lR,100);
    nOfBins = 100; 
    metalListThreshVals(aI) = exp(bins(nOfBins-thresh_query));
end

end