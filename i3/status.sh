#!/usr/bin/env bash
eval "$(pyenv init -)"
export PYENV_VERSION=i3status
python ~/.i3/status.py
