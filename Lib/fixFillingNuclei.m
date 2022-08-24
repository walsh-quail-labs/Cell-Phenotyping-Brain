function Ind = fixFillingNuclei(Ind,Nuc)

[L,n] = bwlabel(~Ind);

for regInd = 1:n
    
    region = find(L==regInd);
    coveredRatio = length(find(Nuc(region)~=0))/length(region);
    if coveredRatio > 0.7
        Ind(region) = 1;
    end
end

end