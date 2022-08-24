

function prepare_JMFMats_with_overlay(scanName,metalJMFtablePath,outcomeJMFPath,regIndPath,ringIndPath,nucleiPath)

metalJMFtable = readtable(metalJMFtablePath);
metalList = metalJMFtable.Metal;
compute_presence_matrix_with_overlay(outcomeJMFPath,metalList,scanName,regIndPath,ringIndPath,nucleiPath);

end