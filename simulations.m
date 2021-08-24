%---------------------------------------------------------
% This script generates the number of white noise realizations
% specified by the experiment and it controls the calls to
% the script worker.m (which computes the Bargmann transform
% and counts its zeros for further processing).
% In particular, this script manages the multi-threaded 
% computation when Octave is used.
% If the chosen software is MATLAB, then the routines are 
% executed without multi-threading.
%---------------------------------------------------------

if (numel(glob(folderTmpDataDS)) > 0); delete(folderTmpDataDS); end
pause(0.5);
if ~exist(folderTmpDataD,'dir') mkdir(folderTmpDataD); end
if ~exist(folderPrecomputedD,'dir') mkdir(folderPrecomputedD); end
if ~exist(folderResults,'dir') mkdir(folderResults); end

%---------------------------------------------------------
% Setting zero detection methods.
%---------------------------------------------------------

comparedMethodsZeroDetection

%---------------------------------------------------------
% Initializing vectors to store data.
%---------------------------------------------------------

zeroSetsDifferenceBoxPartial                                = zeros(length(delta_GAF), runs, zeDetectNo);
numberZerosInnerBoxPartial                                  = zeros(length(delta_GAF), runs, zeDetectNo);
numberZerosInnerBoxSevPartial                               = zeros(length(delta_GAF), runs, zeDetectNo, length(boxSizes));
zeroSetsDifference                                          = zeros(length(delta_GAF), runs, zeDetectNo);
zeroSetsDifferenceBox                                       = zeros(length(delta_GAF), runs, zeDetectNo);
zeroSetsNorm                                                = zeros(length(delta_GAF), runs, zeDetectNo);
referenceZeros                                              = cell(zeDetectNo, length(L));


%---------------------------------------------------------
% Detecting Matlab/Octave.
%---------------------------------------------------------

software                                                    = double(exist('OCTAVE_VERSION', 'builtin') ~= 0)+1;

%---------------------------------------------------------
% If seedMode is enabled, we set the implicit parameter of 
% the number generator to a fixed value to reproduce the 
% results shown in the manuscript.
%---------------------------------------------------------

if seedMode
    if ~(software==1)
        randn('seed', 6.315096632959958e-57);
    end
end

% Setting the length for the noise to be generated to which
% we add some buffer to avoid boundary effects.

H_w                                                     = [-T:delta_GAF(end):T].';
sigLength                                               = length(-L:delta_GAF(end):L);
sigLengthTotal                                          = sigLength + length(H_w);

% Generating noise samples.
qnoiseCell                                               = cell(1, runs);
for ii=1:runs
    qnoiseCell{ii} = sd_noise .* sqrt(delta_GAF(end) .* sqrt(pi/2)) .* (sqrt(0.5) .* ( randn(sigLengthTotal, 1) + 1i .* randn(sigLengthTotal, 1) ));
end

%---------------------------------------------------------
% Calls to the file worker.m.
%---------------------------------------------------------

if (~(software==1) && (distributedComputation || parallelMode))
    while length(missingRuns()) > 0
        maxWorkers = str2num(fileread('maxWorkers.txt'));
        runsStartCycle = activeRuns();
        finishedRunsStartCycle = length(finishedRuns());
        if ( (length(setdiff(missingRuns(), runningProc())) > 0) && (runsStartCycle < maxWorkers) && ...
             (distributedComputation || (~distributedComputation && (ismember(1, finishedRuns()) || ~ismember(1, runningProc())))) )
            try
                nonExecuted = setdiff(missingRuns(), runningProc());
                indexRuns   = nonExecuted(1);
                msg=sprintf('Realization of complex white noise no. %d/%d.\n',  indexRuns, runs);
                fprintf (repmat('-',1,numel(msg)),  indexRuns, runs);
                fprintf ('\n');
                fprintf (msg);
                noiseVector = qnoiseCell{indexRuns};
                savex(fileTmpDataD, 'qnoiseCell');
                pause(0.5);
                if(distributedComputation)
                    execOctaveServer
                else
                    if(ispc)
                        commandTBE  = cleanName(['CMD.EXE /C "START "','" /b /min ',OCTAVE_HOME,'\\bin\\octave-cli.exe --silent worker.m >NUL"']);
                    else
                        commandTBE  = ['octave worker.m > /dev/null 2>&1 '];
                    end
                end
                system (commandTBE, false, 'async'); 
                jj = 0;
                while (~(ismember(indexRuns, union(finishedRuns(), runningProc()))) && (jj < 100) )
                    pause(0.1);
                    jj=jj+1;
                end
            end
        else
            pause(0.1)
        end
    end
    
    fns                                  = glob([folderTmpDataD,'/',partialResults,'*.mat']);
    zeroSetsDifferenceBoxTotal           = zeros(length(delta_GAF), runs, zeDetectNo);
    numberZerosInnerBoxTotal             = zeros(length(delta_GAF), runs, zeDetectNo);
    numberZerosInnerBoxSevTotal          = zeros(length(delta_GAF), runs, zeDetectNo, length(boxSizes));

    for ii=1:numel(fns)
        load(fns{ii});
        zeroSetsDifferenceBoxTotal       = zeroSetsDifferenceBoxTotal+zeroSetsDifferenceBoxPartial;
        numberZerosInnerBoxTotal         = numberZerosInnerBoxTotal+numberZerosInnerBoxPartial;
        numberZerosInnerBoxSevTotal      = numberZerosInnerBoxSevTotal+numberZerosInnerBoxSevPartial;
    end

else

    for indexRuns=1:runs
        msg=sprintf('Realization of complex white noise no. %d/%d.\n',  indexRuns, runs);
        fprintf (repmat('-',1,numel(msg)));
        fprintf ('\n');
        fprintf (msg);
        noiseVector = qnoiseCell{indexRuns};
        worker
    end

    zeroSetsDifferenceBoxTotal      = zeroSetsDifferenceBoxPartial;
    numberZerosInnerBoxTotal        = numberZerosInnerBoxPartial;
    numberZerosInnerBoxSevTotal     = numberZerosInnerBoxSevPartial;
end

failureProbability      = reshape(mean(zeroSetsDifferenceBoxTotal > 0, 2), size(zeroSetsDifferenceBoxTotal,1), size(zeroSetsDifferenceBoxTotal,3));
avNumberZerosInnerBox   = reshape(mean(numberZerosInnerBoxTotal, 2), size(numberZerosInnerBoxTotal,1), size(numberZerosInnerBoxTotal,3));

save(fileSimR, 'zeroDetectionLabel', 'zeDetectNo', 'numberZerosInnerBoxSevTotal', 'numberZerosInnerBoxTotal', 'zeroSetsDifferenceBoxTotal', 'failureProbability', 'avNumberZerosInnerBox');

fprintf('\nEnd of simulation for %s.\n', experimentName)