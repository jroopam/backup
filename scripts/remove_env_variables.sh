#!/bin/bash

sed -i '/export TMUX_STARTED=1/d' ~/.zshenv
touch chli
