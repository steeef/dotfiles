function z --description 'Jump to directory with fzf fallback'
  if test (count $argv) -eq 0
    set -l dir (zoxide query -l | fzf --height 40% --reverse)
    test -n "$dir"; and cd $dir
  else
    __zoxide_z $argv
  end
end
