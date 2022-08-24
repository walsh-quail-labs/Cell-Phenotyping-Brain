function result = imreadTextChannelRaw(Pano,headerIndex)


allData = Pano.data;

sizeI2 = max(allData(:,4))+1;
sizeI1 = max(allData(:,5))+1;


Y = allData(:,4);
X = allData(:,5);
result = zeros(sizeI1,sizeI2);

for itr = 1:length(X)
    if (X(itr)+1 > 0 && X(itr)+1 < sizeI1 && Y(itr)+1 > 0 && Y(itr)+1 < sizeI2) 
        if ~isempty(allData(itr,headerIndex))
            result(X(itr)+1,Y(itr)+1) = allData(itr,headerIndex);
        end
    end
    
end

end


