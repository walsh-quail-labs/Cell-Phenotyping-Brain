function result=findUniqueStrCell(A)

i =1 ;
counter = 1;
prev_type = '';
while i <= length(A)    
    if strcmp(A{i},prev_type) == 0
        result{counter,1} = A{i};
        counter = counter + 1;
        prev_type = A{i};
    end
    i=i+1;
end


end