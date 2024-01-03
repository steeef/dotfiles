{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./keyboard.nix
    ];

  # Bootloader.
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      enableCryptodisk = true;
    };
    kernelModules = [ "coretemp" ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sprice = {
    isNormalUser = true;
    description = "Stephen Price";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      alacritty
      gnome3.gnome-tweaks
    ];
  };

  users.users.malcolm = {
    isNormalUser = true;
    description = "Malcolm";
  };

  fileSystems."/mnt/sprice" = {
    device = "//store/sprice";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100,file_mode=0600,dir_mode=0700,rw" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
    gnome-console
    gedit # text editor
  ]) ++ (with pkgs.gnome; [
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-contacts
    gnome-weather
    gnome-maps
  ]);

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    chromium
    firefox
    fprintd
    git
    gnomeExtensions.tophat
    libgtop
    lm_sensors
    lsof
    cifs-utils
    tailscale
    tigervnc
    vim
    wget
  ];

  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="coretemp"
  '';

  environment.variables = {
    EDITOR = "vim";
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };
  environment.wordlist.enable = true;

  fonts.packages = with pkgs; [
    dejavu_fonts
    fira-code
    hack-font
    jetbrains-mono
    source-code-pro
    victor-mono
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    steam.enable = true;
    zsh.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services = {
    fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };

    fwupd.enable = true;

    mullvad-vpn.enable = true;
    pcscd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    tailscale.enable = true;

    thermald.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      layout = "us";
      xkbVariant = "";
    };
  };


  system.stateVersion = "23.05"; # Did you read the comment?


  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    trusted-substituters = [
      "cache.nixos.org"
      "nix-community.cachix.org"
    ];

    trusted-users = [
      "root"
      "sprice"
    ];
  };

}
