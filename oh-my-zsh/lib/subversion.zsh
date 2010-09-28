# get the revision we're currently at
function svn_prompt_info() {
  ref=$(svn info 2> /dev/null | grep Revision) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#Revision: }$(parse_svn_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

parse_svn_dirty () {
  svnstat=$(svn status 2>/dev/null | grep '\(^M\|^\?\|^D\|^A\|^R\|^\!\|^C\)')

  if [[ $(echo ${svnstat} | grep -c "^\(D\|M\|R\)") > 0 ]]; then
	echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  if [[ $(echo ${svnstat} | grep -c "^\(A\|C\|\?\|\!\)") > 0 ]]; then
	echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi 

  if [[ $(echo ${svnstat} | grep -v '^$' | wc -l | tr -d ' ') == 0 ]]; then
	echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

#
# Will return the current revision number
function current_revision() {
  ref=$(svn info 2> /dev/null | grep Revision) || return
  echo ${ref#Revision: }
}
