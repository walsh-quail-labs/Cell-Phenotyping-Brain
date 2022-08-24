function allCellTypes =main_cell_type_assignment_v3(rule_table_location,outcomeJMFPath,scanName,regIndPath,ringIndPath)

[firstListIndicators,tableHeaders,ruleTable,relationship,before_type,indicators,metals,after_type,sensity_level]=get_the_first_list_indicators(rule_table_location);
% ruleTable = readtable(rule_table_location);

% tableHeaders = ruleTable.Properties.VariableNames;
nOfPasses = length(tableHeaders)/6;
allRegInds = importdata(regIndPath);
nOfCells = length(allRegInds);
allCellTypes = cell(nOfCells,nOfPasses);

for pass_no = 1 : nOfPasses    
                                              
    if pass_no == 1 
        allCellTypes = run_first_pass(outcomeJMFPath,scanName,regIndPath,ringIndPath,firstListIndicators,relationship,indicators,after_type,metals,allCellTypes);
    else
        allCellTypes = type_assignment_per_pass_v3_priority(tableHeaders,allCellTypes,pass_no,ruleTable,outcomeJMFPath,scanName,regIndPath,ringIndPath);
    end


end


end
