function regInd = compute_area_of_a_cell_from_indices(curB,sizeImage)


%Y = curB(:,2);
%X = curB(:,1);
[X,Y] = ind2sub(sizeImage,curB);

minX = min(X);
minY = min(Y);
maxX = max(X);
maxY = max(Y);
X = X-minX+1;
Y = Y-minY+1;
markedBoundary = zeros(maxX-minX+1,maxY-minY+1);
X2 = [X(2:end);X(1)];
Y2 = [Y(2:end);Y(1)];
X = [X;(X+4*X2)/5;(2*X+3*X2)/5;(3*X+2*X2)/5;(4*X+X2)/5;(X+X2)/2];
Y = [Y;(Y+4*Y2)/5;(2*Y+3*Y2)/5;(3*Y+2*Y2)/5;(4*Y+Y2)/5;(Y+Y2)/2];
X = min(max(floor(X),1),size(markedBoundary,1));
Y = min(max(floor(Y),1),size(markedBoundary,2));
cur_nuc_inds = sub2ind(size(markedBoundary),X,Y);
markedBoundary(cur_nuc_inds) = 1;
markedBoundary = imfill(markedBoundary);
[regX,regY] = ind2sub(size(markedBoundary),find(markedBoundary~=0));
regX = max(min(regX+minX,sizeImage(1)),1);
regY = max(min(regY+minY,sizeImage(2)),1);
regInd = sub2ind(sizeImage,regX,regY);

end