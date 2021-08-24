function out = runningProc()
%runningProc  Number of running instances.
%   Usage:  out = runningProc()
%
%   Input: none.
%
%   Output:
%   out              :  the number of active instances obtained via the count of *.lock files in the tmpFolder.
%
%---------------------------------------------------------
global tmpFolder;
out = [];
fns = glob ([tmpFolder,'/*.lock']);
for ii=1:length(fns)
    [a,b,c] = fileparts(fns{ii});
    out = [out, str2num(b)];
end