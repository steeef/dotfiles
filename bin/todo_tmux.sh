#!/bin/bash
#
# todo_tmux.sh
# Wrapper for todo.sh (todotxt) and tmux
#

TODO=~/.bin/todo.sh
TMUX_SESSION_NAME=todotxt
# Check that tmux is installed and there is a session with the expected name
command -v tmux >/dev/null 2>&1 && \
    (tmux ls -F '#S' | grep -q "${TMUX_SESSION_NAME}") && USE_TMUX=1
$TODO $*

# Force Clam (within Vim) to reload todo.txt
if [ "${USE_TMUX}" -eq "1" ]; then
    tmux send-keys -l -t "${TMUX_SESSION_NAME}:0.0" '\r'
fi
