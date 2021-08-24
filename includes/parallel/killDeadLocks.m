% Kills Octave running in the remote servers.
system (['ssh ',userName,'@',cell2mat(availableServers(:,jj))," \"cd $(pwd); ./killOctave > /dev/null 2>&1\" "], 0, "async");