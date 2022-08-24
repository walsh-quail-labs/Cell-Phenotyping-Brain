function allCellTypes = run_first_pass(outcomeJMFPath,scanName,regIndPath,ringIndPath,firstListIndicators,relationship,indicators,after_type,metals,allCellTypes)

NONE_THRESH = 0.07;
pass_no = 1;
JMFPath = fullfile(outcomeJMFPath,scanName);
% nOfInds = length(metalList);
allRegInds = importdata(regIndPath);
allRingInds = importdata(ringIndPath);
nOfCells = length(allRegInds);
newCellTypes = cell(nOfCells,1);

rel_exits = 1;
if isa(relationship,'double')
    rel_exits = 0;
end
% final_presence_matrix = zeros(imsize);
nOfRuleRows = size(relationship,1);
rule_row_itr = 1;
arri = [];
while(rule_row_itr<=nOfRuleRows)
    if ~isempty(indicators{rule_row_itr})
        if rel_exits && strcmp(relationship{rule_row_itr},'AND')
            
            %             disp('AND relationship is being implemented');
            rri = rule_row_itr;
            cur_peresence_matrix = imbinarize(im2double(imread(fullfile(JMFPath,strcat(firstListIndicators{rri},'_2.png')))));
            arri = [arri;rri];
            while rri<=nOfRuleRows && strcmp(relationship{rri},'AND')
                rri = rri+1;
                if strcmp(relationship{rri},'AND')
                    arri = [arri;rri];
                    cur_peresence_matrix = and(cur_peresence_matrix,imbinarize(im2double(imread(fullfile(JMFPath,strcat(firstListIndicators{rri},'_2.png'))))));
                end
            end
            imwrite(cur_peresence_matrix,fullfile(JMFPath,strcat(after_type{rule_row_itr},'_2.png')));
            imwrite(cur_peresence_matrix,fullfile(JMFPath,strcat(after_type{rule_row_itr},'_1.png')));
            firstListIndicators{length(firstListIndicators)+1} = after_type{rule_row_itr};
        end
    end
    rule_row_itr = rule_row_itr+1;
end
firstListIndicators(unique(arri)) = [];
firstListIndicators = uniqueStrCell(firstListIndicators);



nuc_presence_matrix = zeros(nOfCells,length(firstListIndicators));
for j = 1 : length(firstListIndicators)
    
    curMask = im2double(imread(fullfile(JMFPath,strcat(firstListIndicators{j},'_2.png'))));
    for i = 1 : nOfCells
        nuc_presence_matrix(i,j) = sum(curMask(allRegInds{i}))/length(allRegInds{i});   
    end
end
ring_presence_matrix = zeros(nOfCells,length(firstListIndicators));
for j = 1 : length(firstListIndicators)
    
    curMask = im2double(imread(fullfile(JMFPath,strcat(firstListIndicators{j},'_2.png'))));
    for i = 1 : nOfCells
        ring_presence_matrix(i,j) = sum(curMask(allRingInds{i}))/length(allRingInds{i});   
    end
end
presence_matrix = nuc_presence_matrix;
% presence_matrix = max(nuc_presence_matrix,ring_presence_matrix);

[highIndicatorVals,highIndicatorIds] = max(presence_matrix,[],2);
for cellItr = 1 : nOfCells    
if highIndicatorVals(cellItr) >= NONE_THRESH
    
    T = find(contains(metals,firstListIndicators{highIndicatorIds(cellItr)}));
    if ~isempty(T)
        newCellTypes{cellItr} = after_type{T};
    else
        disp('this happened')
        newCellTypes{cellItr} = firstListIndicators{highIndicatorIds(cellItr)};
    end
else
    newCellTypes{cellItr} = 'NONE';
end
allCellTypes(:,pass_no) = newCellTypes;

end


