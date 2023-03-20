ZGEN_COMPINIT_FLAGS='-i'
ZSH_COMPDUMP="${HOME}/.zcompdump_${ZSH_VERSION}"
ZGEN_CUSTOM_COMPDUMP="${ZSH_COMPDUMP}"
export ZSH_COMPDUMP

# Add some completions settings
setopt ALWAYS_TO_END     # Move cursor to the end of a completed word.
setopt AUTO_LIST         # Automatically list choices on ambiguous completion.
setopt AUTO_MENU         # Show completion menu on a successive tab press.
setopt AUTO_PARAM_SLASH  # If completed parameter is a directory, add a trailing slash.
setopt COMPLETE_IN_WORD  # Complete from both ends of a word.
unsetopt MENU_COMPLETE   # Do not autoselect the first completion entry.

# install and load zgenom
ZGEN_DIR="${HOME}/.zgenom"
export ZGEN_DIR
if [ ! -d "${ZGEN_DIR}" ]; then
  git clone "https://github.com/jandamm/zgenom.git" "${ZGEN_DIR}"
fi
source "${ZGEN_DIR}/zgenom.zsh"
