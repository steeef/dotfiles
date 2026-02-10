{pkgs, ...}: {
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    ncdu
    stdenv.cc.cc.lib
  ];

  home.shellAliases = {
    hms = "home-manager switch --flake $HOME/.dotfiles#$USER@linux";
    nr = "sudo nixos-rebuild switch --flake $HOME/.dotfiles#nixos";
  };

  systemd.user.services.ssh-agent = {
    Unit = {
      Description = "SSH key agent";
    };

    Service = {
      Type = "simple";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
      ExecStart = ''
        /usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK
      '';
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };

  imports = [
    ./backup.nix
  ];
}
