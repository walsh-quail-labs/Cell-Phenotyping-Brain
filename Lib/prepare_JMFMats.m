

function cIMat = prepare_JMFMats(scanName,metalJMFtablePath,outcomeJMFPath,cIMatOuputFolder,regIndPath,ringIndPath)

metalJMFtable = readtable(metalJMFtablePath);
metalList = metalJMFtable.Metal;
nuc_presence_matrix = compute_presence_matrix(outcomeJMFPath,metalList,scanName,regIndPath);
ring_presence_matrix = compute_presence_matrix(outcomeJMFPath,metalList,scanName,ringIndPath);
cIMat = max(nuc_presence_matrix,ring_presence_matrix);
if ~exist(cIMatOuputFolder,'dir')
    mkdir(cIMatOuputFolder)
end
save(fullfile(cIMatOuputFolder,strcat(scanName,'.mat')),'cIMat');

end