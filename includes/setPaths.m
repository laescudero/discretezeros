%---------------------------------------------------------
% Paths to files and folders.
%---------------------------------------------------------

fileNumD           = cleanName(['./',precomputedFolder,'/',experimentName,'/',numericalBigBoxName,'.mat']);
filePlotCode	   = cleanName(['./',outputFolder,'/',experimentName,'/','fig','_',experimentName,'.tex']);	
fileSimR           = cleanName(['./',outputFolder,'/',experimentName,'/',fileRawFilesSave,'.mat']);
fileTablePfal      = cleanName(['./',outputFolder,'/',experimentName,'/','table3','_',fileProbFailureTableName,'_',experimentName,'.tex']);
fileTableMeanSD    = cleanName(['./',outputFolder,'/',experimentName,'/','table1','_',experimentName,'.tex']);
fileTmpDataD       = cleanName(['./',tmpFolder,'/',fileTmpData,'.mat']);
folderResults      = cleanName(['./',outputFolder,'/',experimentName,'/']);
folderPrecomputedD = cleanName(['./',precomputedFolder,'/',experimentName]);
folderTmpDataD     = cleanName(['./',tmpFolder,'/']);
folderTmpDataDS    = cleanName(['./',tmpFolder,'/*']);
