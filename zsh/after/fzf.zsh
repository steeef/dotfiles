# fzf in tmux pane
[ -n "$TMUX" ] && export FZF_TMUX=1

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="bfs ~ -nohidden -type d -printf '~/%P\n'"

source "${ZGEN_DIR}/junegunn/fzf-___/shell/completion.zsh"
source "${ZGEN_DIR}/junegunn/fzf-___/shell/key-bindings.zsh"
