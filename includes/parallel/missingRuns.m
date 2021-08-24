function out = missingRuns()
%missingRuns  Return the number of missing results when using the distributed computation.
%---------------------------------------------------------

global runs;
allEntries = [1:runs];
out = setdiff(allEntries, finishedRuns);