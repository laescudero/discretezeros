% Kills Octave running in the remote servers.
parameters
for jj=1:length(availableServers)
	pathA = pwd;
	system (['ssh ',userName,'@',cell2mat(availableServers(:,jj))," \"cd ",pathA,"; ./includes/parallel/killOctave > /dev/null 2>&1\" "], false, "async");
end