clear all
close all
clc

%---------------------------------------------------------
% Adding auxiliary folders to the default path.
%---------------------------------------------------------

projectdir = pwd;

addpath(genpath([pwd,'/','includes']))

if (~double(exist('OCTAVE_VERSION', 'builtin')))
    addpath([pwd,'/matlab_includes/']);
end

%---------------------------------------------------------
% Loading global settings.
%---------------------------------------------------------

parameters

%---------------------------------------------------------
% Iterate over experiments.
%---------------------------------------------------------

expFolderD      = [expFolder,'/*.m'];
experimentList  = glob(expFolderD);

if ~silentMode
    msg = 'Do you want to run all the available experiments?';
    choiceAll = menu(msg,'Yes','No');
    checkExperiment = false;
    if (choiceAll==2 || choiceAll==0)
       checkExperiment = true;
    end

    msg = 'Do you want to run the entire simulation or compute the stats of previously computed simulations?';
    choiceRS = menu(msg,'Simulations and statistics','Only simulations', 'Only statistics');
    if (choiceRS==1 || choiceRS==0)
        doSims = true;
        doStats = true;
    elseif (choiceRS==2)
        doSims = true;
        doStats = false;
    else
        doSims = false;
        doStats=true;
    end
else
    checkExperiment = false;
    doSims = true;
    doStats = true;
end
    
for ii=1:length(experimentList)
    close all
    [filepath, experimentName, ext] = fileparts(experimentList{ii});
    if (checkExperiment)    
        msg = sprintf('Do you want to execute the experiment %s?', experimentName);
        choiceExp = menu(msg,'Yes','No');
        if (choiceExp==2 || choiceExp==0)
           continue;
        end
    end
    fprintf('Processing experiment %s.\n', experimentName);
    run(experimentList{ii});
    cd(projectdir);
    setPaths
    if (doSims)
        simulations
    end
    if (doStats)
        statsims
        preplot_dataFig5
    end
end