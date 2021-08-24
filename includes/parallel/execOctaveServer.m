% Executes the file worker.m in a remote host via SSH.
pathA = pwd;
commandTBE  = ['ssh ',userName,'@',cell2mat(availableServers(:,1+mod(indexRuns-1,length(availableServers))))," \"cd '",pathA,"'; octave worker.m > /dev/null 2>&1 \" "];