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

```sh
git clone <this-repo> ~/.dotfiles
./.dotfiles/bin/bootstrap.sh
```

You can then use the alias `hms` to run `home-manager switch` to update things periodically.

# MacOS setup

On MacOS, this will also install Homebrew. I use [nix-darwin](https://github.com/LnL7/nix-darwin) to separately
configure my MacOS machines, but this install is not yet currently automated.

First add a `darwinConfigurations` block for your machine near the bottom of [flake.nix](flake.nix):

```nix
      darwinConfigurations.<machine> = mkDarwinConfig {
        system = "x86_64-darwin";
        machine = "<machine>";
      };
```

Then you can set up `nix-darwin` by following the steps below:

```sh
# run the initial build of the nix-darwin derivation
nix build $HOME/.dotfiles#darwinConfigurations.<machine>.system

# nix-darwin needs a symlink for /run, so ask MacOS to do it for us
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
# call apfs.util -t to create it without having to reboot
sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# now call darwin-rebuild on the derivation created by "nix build"
./result/sw/bin/darwin-rebuild switch --flake ./.dotfiles

# this will result in some errors that you can work around with similar edits to files.
# you may need to fix symlinks or call the following commands to source files under /etc/static. This all depends on
# the errors you see from the first call to darwin-rebuild
echo 'if test -e /etc/static/bashrc; then . /etc/static/bashrc; fi' | sudo tee -a /etc/bashrc
echo 'if test -e /etc/static/zshrc; then . /etc/static/zshrc; fi' | sudo tee -a /etc/zshrc
echo 'if test -e /etc/static/zshenv; then . /etc/static/zshenv; fi' | sudo tee -a /etc/zshenv
sudo ln -sfn /etc/static/nix/nix.conf /etc/nix/nix.conf

# call darwin-rebuild one more time to verify things are fixed:
./result/sw/bin/darwin-rebuild switch --flake ./.dotfiles
```

after that the `dr` alias should be available to run `darwin-rebuild switch`.

*NOTE:* if at any point you see errors like "Operation not permitted", it's likely you need to give `nix` `Full Disk
Access` permissions (System Preferences/Settings -> Security & Privacy -> Privacy tab -> Full Disk Access).

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

# Acknowledgements

* Julia Evans' article ["Some notes on using nix"](https://jvns.ca/blog/2023/02/28/some-notes-on-using-nix/) was what
  originally got me excited about trying out Nix, since her guides are very thorough and explain everything plainly.
* [Zero to Nix](https://zero-to-nix.com/), a site run by Determinate Systems with a good introduction to Nix concepts.
* xyno's [blog article](https://xyno.space/post/nix-darwin-introduction) explaining how he learned about Nix via
  installing and developing flakes in MacOS. It helped me when troubleshooting my installs on MacOS as well.
