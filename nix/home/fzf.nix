{...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --no-ignore --hidden --follow -g '!{.git,node_modules}/*' 2> /dev/null";

    # Dracula colors
    defaultOptions = [
      "--color=dark"
      "--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f"
      "--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
    ];
    fileWidgetCommand = "rg --files --no-ignore --hidden --follow -g '!{.git,node_modules}/*' 2> /dev/null";
    changeDirWidgetCommand = "bfs ~ -nohidden -type d -printf '~/%P\\n' 2> /dev/null";
    tmux.enableShellIntegration = true;
  };
}
