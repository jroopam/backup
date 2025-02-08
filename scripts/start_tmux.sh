#!/bin/bash
 
# local tmux_attached=$(tmux ls | grep -v attached | cut -d: -f1)
# tmux_session="sess"
# if [ -n "$tmux_attached" ]; then
#     tmux attach-session -t "$tmux_attached"
# else 
    # tmux -u new-session -s "$tmux_session" -d
    # tmux new-window -t "$tmux_session" 
    # tmux send-keys -t "$tmux_session" "nvim -S ~/SESSION" Enter
    # tmux -u attach-session -t "$tmux_session":0
# fi
