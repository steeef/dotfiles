# fzf in tmux pane
[ -n "$TMUX" ] && export FZF_TMUX=1

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="bfs ~ -nohidden -type d -printf '~/%P\n' 2> /dev/null"

fzfdir="${HOME}/.nix-profile/share/fzf"

if [ -d "${fzfdir}" ]; then
  source "${fzfdir}/completion.zsh"
  source "${fzfdir}/key-bindings.zsh"
fi
