#!/bin/bash
#
TMUX=/opt/local/bin/tmux
TMUX_SESSION_NAME=todotxt
# Check that tmux is installed and there is a session with the expected name
/usr/bin/logger "todo.txt changed"
command -v $TMUX >/dev/null 2>&1 && \
    ($TMUX ls -F '#S' | grep -q "${TMUX_SESSION_NAME}") && USE_TMUX=1

# Force Clam (within Vim) to reload todo.txt
if [ "${USE_TMUX}" -eq "1" ]; then
    $TMUX send-keys -l -t "${TMUX_SESSION_NAME}:0.0" '\r'
else
    /usr/bin/logger "tmux not working"
fi
