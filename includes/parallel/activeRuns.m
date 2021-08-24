function out = activeRuns()
%activeRuns  Return the number of running processes when using the distributed computation.
%---------------------------------------------------------

out = length(runningProc);

end