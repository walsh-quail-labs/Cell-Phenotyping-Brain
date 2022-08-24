
function allCellTypes = type_assignment_per_pass_v3_priority(tableHeaders,allCellTypes,pass_no,ruleTable,outcomeJMFPath,scanName,regIndPath,ringIndPath)



before_type = ruleTable(:,contains(tableHeaders,strcat('TYPE_BEFORE_',num2str(pass_no)))).Variables;
indicators = ruleTable(:,contains(tableHeaders,strcat('IND_',num2str(pass_no)))).Variables;
metals = ruleTable(:,contains(tableHeaders,strcat('METAL_',num2str(pass_no)))).Variables;
after_type = ruleTable(:,contains(tableHeaders,strcat('TYPE_AFTER_',num2str(pass_no)))).Variables;
sensity_level = ruleTable(:,contains(tableHeaders,strcat('Sensitivity_Level_',num2str(pass_no)))).Variables;


BIG_THRESH = 0.5;
% metalJMFtable = readtable(metalJMFtablePath);
% metalList = metalJMFtable.Metal;
JMFPath = fullfile(outcomeJMFPath,scanName);
allRegInds = importdata(regIndPath);
allRingInds = importdata(ringIndPath);

sensity_level  = BIG_THRESH+sensity_level;

before_type_exist = 1;
if isa(before_type,'double')
    before_type_exist = 0;
end

nOfRuleRows = size(ruleTable,1);


nOfCells = size(allCellTypes,1);
if pass_no == 1
    cellTypesBefore = cell(nOfCells,1);
else
    cellTypesBefore = allCellTypes(:,pass_no-1);
end

newCellTypes = cellTypesBefore;


rule_row_itr = 1;
while(rule_row_itr<=nOfRuleRows)
    
    if ~isempty(indicators{rule_row_itr})
        
        
        % is there is a before type
        if before_type_exist && ~isempty(before_type{rule_row_itr})
            candidate_cell_ids = [];
            for i = 1 : nOfCells
                if strcmp(newCellTypes{i},before_type{rule_row_itr})==1
                    candidate_cell_ids = [candidate_cell_ids;i];
                end
            end
        else
            
            candidate_cell_ids = [];
            for i = 1 : nOfCells
                if isempty(newCellTypes{i})
                    candidate_cell_ids = [candidate_cell_ids;i];
                end
            end
        end
        
                        
        cur_rule_row_ind = indicators{rule_row_itr};        
        sign_pos_neg = cur_rule_row_ind(end);
        
        if strcmp(sign_pos_neg,'+') % NEGATIVE
            sign_pos_neg = 1;
        elseif strcmp(sign_pos_neg,'-') % POSITIVE
            sign_pos_neg = -1;
        else % ELSE
            sign_pos_neg = 0;
        end
        
        
        else_cond = 0;
        fullfile(JMFPath,strcat(metals{rule_row_itr},'_2.png'))
        if ~isempty(metals{rule_row_itr})   
            curMask = im2double(imread(fullfile(JMFPath,strcat(metals{rule_row_itr},'_2.png'))));    
        else
            else_cond = 1;
        end
        
        for i = 1 : length(candidate_cell_ids)
            cI = candidate_cell_ids(i);
            if else_cond==0
                score1 = sum(curMask(allRegInds{cI}))/length(allRegInds{cI});   
                score2 = sum(curMask(allRingInds{cI}))/length(allRingInds{cI}); 
                score_max = score1;
%                 score_max = max(score1,score2);
            end
            if sign_pos_neg == 1
                if score_max >= sensity_level(rule_row_itr)
                    newCellTypes{cI} = after_type{rule_row_itr};
                end
            elseif sign_pos_neg == -1
                if score_max < sensity_level(rule_row_itr)
                    newCellTypes{cI} = after_type{rule_row_itr};
                end
            else
                if pass_no >= 2 
                    newCellTypes{cI} = after_type{rule_row_itr};
                end
            end
        end
        
    end
    rule_row_itr = rule_row_itr+1;
end



for i = 1 : length(newCellTypes)
    if isempty(newCellTypes{i})
        newCellTypes{i}='NONE';
    end
end


allCellTypes(:,pass_no) = newCellTypes;

end



