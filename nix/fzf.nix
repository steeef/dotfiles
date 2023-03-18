{ ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --no-ignore --hidden --follow -g \"!{.git,node_modules}/*\" 2> /dev/null";
    fileWidgetCommand = "rg --files --no-ignore --hidden --follow -g \"!{.git,node_modules}/*\" 2> /dev/null";
    changeDirWidgetCommand = "bfs ~ -nohidden -type d -printf '~/%P\\n' 2> /dev/null";
    tmux.enableShellIntegration = true;
  };
}
