function finalMask=computeMaskWithWeights(result,topK)
w = 3;
%result = uint8(result*255);
I = medfilt2(result,[w w]);


nClust = 5;

while 1
    [L,~] = imsegkmeans(I,nClust);
    meanInt = zeros(nClust,1);
    
    for i = 1 : nClust
        meanInt(i) = mean(I(L==i));
    end
    
    
    [~,sI]=sort(meanInt,'descend');
    mask = zeros(size(L));
    for i = 1 : topK
        mask(L==sI(i)) = 1;
    end
    mask = bwareaopen(mask,20);
    %mask = imdilate(mask,strel('disk',2));
    maskMean = mean(mean(mask));
    
    if(abs(1-maskMean)>0.1)
        break;
    else
        if nClust >= 2 && topK >=1
            
            
            nClust = nClust-1;
            topK = topK-1;
        else
            break;
        end
    end
end
finalMask = mask;

end


