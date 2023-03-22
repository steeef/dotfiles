```
 ___________________
< steeef's dotfiles >
 -------------------
 \     /\  ___  /\
  \   // \/   \/ \\
     ((    O O    ))
      \\ /     \ //
       \/  | |  \/
        |  | |  |
        |  | |  |
        |   o   |
        | |   | |
        |m|   |m|
```

# Dotfiles with Nix, Home Manager, and nix-darwin

<img src="https://user-images.githubusercontent.com/77589/226965659-00882024-4c02-49f3-a367-0a8da62669d6.svg" width="100" height="87" alt="Nix logo">

I'm currently in the process of rewriting a lot of this in Nix installer and documentation), so a lot of this is in flux.

To both install Nix and get [Home Manager](https://github.com/nix-community/home-manager) to set up your home
directory, you can run the [bootstrap script](/bin/bootstrap.sh):

```
git clone <this-repo> ~/.dotfiles
./.dotfiles/bin/bootstrap.sh
```

You can then use the alias `hms` to run `home-manager switch` to update things periodically.

On MacOS, this will also install Homebrew. I use [nix-darwin](https://github.com/LnL7/nix-darwin) to separately
configure my MacOS machines, but this install is not yet currently automated. You should be able to install and
configure it via:

```
nix build .#darwinConfigurations.<your-hostname>.system --extra-experimental-features "nix-command flakes"
# allow Nix to create a symlink:
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
# now call darwin-rebuild:
./result/sw/bin/darwin-rebuild switch --flake ./.dotfiles
# this will result in some errors that you can work around thusly:
echo 'if test -e /etc/static/bashrc; then . /etc/static/bashrc; fi' | sudo tee -a /etc/bashrc
echo 'if test -e /etc/static/zshrc; then . /etc/static/zshrc; fi' | sudo tee -a /etc/zshrc
echo 'if test -e /etc/static/zshenv; then . /etc/static/zshenv; fi' | sudo tee -a /etc/zshenv
sudo ln -sfn /etc/static/nix/nix.conf /etc/nix/nix.conf
# call darwin-rebuild one more time to verify things are fixed:
./result/sw/bin/darwin-rebuild switch --flake ./.dotfiles
```

after that the `dr` alias should run `darwin-rebuild switch`.

# What you get

In flux, but you should get:

* The same list of command line utilities available on Linux and MacOS hosts.
* Neovim as the default editor with a whole bunch of plugins installed.
* `fzf` for fuzzy-finding in lists (e.g., zsh command history, directories, git branches)
* Mac: `iTerm2` also installed via Home Manager on MacOS and synchronized to
[its config](/nix/home/darwin/iterm2/com.googlecode.iterm2.plist).
* Mac: `Virtual Studio Code` installed via Home Manager on MacOS.
* Mac: Home Manager should create aliases in MacOS for its GUI apps in `~/Applications/Nix`.
* Mac: `nix-darwin` should configure global settings according to my liking.
* Mac: `Alfred` with a (hopefully) synchronized preferences directory.
