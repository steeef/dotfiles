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

I'm currently in the process of rewriting a lot of this in Nix (based on the [Zero to Nix](https://zero-to-nix.com/)
installer and documentation), so a lot of this is in flux.

Theoretically, you can install things with:

```
git clone <this-repo> ~/.dotfiles
./.dotfiles/bin/bootstrap.zsh
./.dotfiles/bin/nix_bootstrap.zsh
```

I'm currently working on consolidating things into a single script that just downloads Nix and builds things with [Home
Manager](https://github.com/nix-community/home-manager).
