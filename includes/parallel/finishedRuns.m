function out = finishedRuns()
%activeRuns  Return the number of finished processes when using the distributed computation.
%---------------------------------------------------------

global tmpFolder;
global partialResults;
out = [];
fns = glob ([tmpFolder,'/',partialResults,'*.mat']);
for ii=1:length(fns)
    [a,b,c] = fileparts(fns{ii});
    pos     = find(b=='_');
    b       = b(pos+1:end);
    out = [out, str2num(b)];
end
out = sort(out);