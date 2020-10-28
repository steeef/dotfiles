whitenoise() { play -q -c 2 -n synth brownnoise band -n 1600 1500 tremolo .1 30 & }

#Use Pygments to color less
pless() { pygmentize -f terminal256 -g -P style=monokai $* | less -FiXRM }

# delete ssh host when keys are bad
function delhost() {
  sed -i -e "$@d" ~/.ssh/known_hosts
}

# bootstrap dotfiles
function sshboot() {
  if [ -n "$1" ]; then
    ssh -t $1 "curl -sL https://gist.githubusercontent.com/steeef/2cf6345055bdec2c9b8781267e8299ab/raw/download_and_bootstrap.sh | bash -ex; bash -l"
  else
    echo "USAGE: sshboot <host>"
  fi
}

function notify() {
  if [ -n "$1" ]; then
    osascript -e 'display notification "'"$1"'" with title "Notify"' && say "$1"
  else
    echo "USAGE: notify <message>"
  fi
}
