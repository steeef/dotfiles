#!/usr/bin/env bash
export PYENV_ROOT="$HOME/.pyenv"
exec pyenv exec "$(basename "$0")" "$@"
