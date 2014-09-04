source ~/.bash/completions
source ~/.bash/aliases
source ~/.bash/paths
source ~/.bash/config
source ~/.bin/z.sh
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi
