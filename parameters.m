global runs;
global tmpFolder;
global cRange;
global partialResults;

%---------------------------------------------------------
% Silent Mode.
% By setting this option as true the main script will 
% compute all the experiments and their statistics without
% requiring any user interaction.
%---------------------------------------------------------
silentMode                                                    = false;

%---------------------------------------------------------
% Seed Mode.
% By setting this option as true you define the implicit
% parameter of the random number generator to a specific value,
% reproducing the results shown in the manuscript.
%---------------------------------------------------------
seedMode                                                      = true;

%---------------------------------------------------------
% Paths and filenames
%---------------------------------------------------------

% Relative path to the folder where the plots and the tables
% will be saved.
outputFolder                                                  = 'results';
tmpFolder                                                     = 'tmpFolder';
expFolder                                                     = 'experiments';
precomputedFolder                                             = 'precomputed';
% Names for the files where the results will be saved.
fileRawFilesSave                                              = 'variables';
fileTmpData                                                   = 'tmpdata';
fileSampleNoiseSaddle                                         = 'noiseSaddle';
fileProbFailureTableName                                      = 'pfal';
numericalBigBoxName                                           = 'numerical_BigBox';
partialResults                                                = 'partialResults';
printLatex                                                    = true;

%---------------------------------------------------------
% Plots parameters
%---------------------------------------------------------
plotSpectrograms                                              = true;
scatterSize                                                   = 60;
cRange                                                        = [-60, 10];

%---------------------------------------------------------
% Parallelization parameters
%---------------------------------------------------------
% parallelMode is only compatible with Octave.
% For the distributedComputation check the Readme.
parallelMode                                                  = false;
% When parallelMode is set to true the maximum number 
% of threads can be defined in maxWorkers.txt
distributedComputation                                        = false;
userName                                                      = 'yourUsername';
availableServers                                              = {'yourServer1', 'yourServer2'};