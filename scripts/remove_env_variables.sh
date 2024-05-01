#!/bin/bash

# This scipt should run when the computer shuts down, but as tmux is its environment so when you do tmux kill-server it executes this scirpt
sed -i '/export TMUX_STARTED=1/d' ~/.zshenv
