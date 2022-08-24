function cellMeanIntensityMatrix = generate_cell_intensity_per_scan_filepath_with_config(CombinedFlag,panoFilePath,allRegIndsPath,IndicatorsList)


if CombinedFlag == 0

    % read channels (Pano)
    [~,Pano] = imreadText(panoFilePath);

    for lt = 1:length(IndicatorsList) 
        lookupQuery = IndicatorsList{lt};
        headerIndex = find(contains(Pano.textdata,lookupQuery));
        allChanelImages{lt} = imreadTextChannelRaw(Pano,headerIndex);  
    end


    % read nuclei
    allRegInds = importdata(allRegIndsPath);

    nOfCells = length(allRegInds);
    nOfInds = length(IndicatorsList);
    cellMeanIntensityMatrix = zeros(nOfCells,nOfInds);
    for i = 1 : nOfCells
        for j = 1 : nOfInds
            Ch = allChanelImages{j};  
            if ~isempty(allRegInds{i})
                cellMeanIntensityMatrix(i,j) = mean(Ch(allRegInds{i}));
            end
        end
    end
    
else
    
    nOfInds = length(IndicatorsList);
    
    cellMeanIntensityMatrix = zeros(1,nOfInds);
    
    for fileITR = 1 : length(panoFilePath)
        
        
        % read channels (Pano)
        [~,Pano] = imreadText(panoFilePath{fileITR});

        for lt = 1:length(IndicatorsList) 
            lookupQuery = IndicatorsList{lt};
            headerIndex = find(contains(Pano.textdata,lookupQuery));
            allChanelImages{lt} = imreadTextChannelRaw(Pano,headerIndex);  
        end


        % read nuclei
        allRegInds = importdata(allRegIndsPath{fileITR});

        nOfCells = length(allRegInds);
        
        cur_cellMeanIntensityMatrix = zeros(nOfCells,nOfInds);
        for i = 1 : nOfCells
            for j = 1 : nOfInds
                Ch = allChanelImages{j};  
                if ~isempty(allRegInds{i})
                    cur_cellMeanIntensityMatrix(i,j) = mean(Ch(allRegInds{i}));
                end
            end
        end
        cellMeanIntensityMatrix = [cellMeanIntensityMatrix;cur_cellMeanIntensityMatrix];
        
        
    end
    cellMeanIntensityMatrix(1,:) = [];        

end


end