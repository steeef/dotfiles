# stopgap for herdrdev/herdr#3256 stale-cwd resume
claude() {
  setopt local_options null_glob
  if [[ -o interactive ]]; then
    local a prev='' id=''
    for a in "$@"; do
      [[ "$prev" == --resume || "$prev" == -r ]] && { id="$a"; break }
      [[ "$a" == --resume=* ]] && { id="${a#--resume=}"; break }
      prev="$a"
    done
    if [[ "$id" =~ '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$' ]]; then
      local t dir=''
      for t in ~/.claude/projects/*/"$id".jsonl; do
        [[ -f "$t" ]] || continue
        dir=$(command sed -n '/"cwd":"\//{s/.*"cwd":"\([^"]*\)".*/\1/p;q;}' "$t")
        [[ -n "$dir" ]] && break
      done
      if [[ -z "$dir" ]]; then
        print -u2 "[claude-resume] no transcript found for $id"
      elif [[ "$dir" != "$PWD" ]]; then
        if [[ -d "$dir" ]]; then
          print -u2 "[claude-resume] cd to $dir"
          builtin cd -- "$dir"
        else
          print -u2 "[claude-resume] $id wants $dir, missing"
        fi
      fi
    fi
  fi
  command claude "$@"
}
