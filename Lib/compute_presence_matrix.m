function presence_matrix = compute_presence_matrix(outcomeJMFPath,metalList,scanName,regIndPath)


JMFPath = fullfile(outcomeJMFPath,scanName);
nOfInds = length(metalList);
allRegInds = importdata(regIndPath);
nOfCells = length(allRegInds);
presence_matrix = zeros(nOfCells,nOfInds);
alpha = 0.9;

for j = 1 : nOfInds
    curMask = imread(fullfile(JMFPath,strcat(metalList{j},'_2.png')));
    
    if strcmp(metalList{j},'Yb176Di')
        curMask = imdilate(curMask,strel('disk',2));
    end
    
    curImage = imread(fullfile(JMFPath,strcat(metalList{j},'_1.png')));
    
    curImage = im2double(curImage);
    if ~isempty(find(curMask==1, 1))
        curImage = curImage/mean(curImage(curMask==1));
    end
    for i = 1 : nOfCells
        presence_matrix(i,j) = sum(curMask(allRegInds{i}))/length(allRegInds{i});   
    end
    
end

