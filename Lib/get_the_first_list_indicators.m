function [firstListIndicators,tableHeaders,ruleTable,relationship,before_type,indicators,metals,after_type,sensity_level]=get_the_first_list_indicators(rule_table_location)
pass_no = 1;
ruleTable = readtable(rule_table_location);
tableHeaders = ruleTable.Properties.VariableNames;
firstListIndicators = ruleTable(:,contains(tableHeaders,strcat('METAL_',num2str(pass_no)))).Variables;
firstListIndicators = firstListIndicators(~cellfun(@isempty, firstListIndicators));
relationship = ruleTable(:,contains(tableHeaders,strcat('RELATIONSHIP_',num2str(pass_no)))).Variables;
before_type = ruleTable(:,contains(tableHeaders,strcat('TYPE_BEFORE_',num2str(pass_no)))).Variables;
indicators = ruleTable(:,contains(tableHeaders,strcat('IND_',num2str(pass_no)))).Variables;
metals = firstListIndicators;
after_type = ruleTable(:,contains(tableHeaders,strcat('TYPE_AFTER_',num2str(pass_no)))).Variables;
sensity_level = ruleTable(:,contains(tableHeaders,strcat('Sensitivity_Level_',num2str(pass_no)))).Variables;


