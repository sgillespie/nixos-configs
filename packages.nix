# Packages/programs configuration
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    alsaUtils
    bashInteractive
    binutils
    corefonts
    curl
    docker
    docker_compose
    elinks
    emacs
    feh
    firefox
    gcc
    gnumake
    ghc
    gitAndTools.gitFull
    irssi
    lightdm
    python3
    python36Packages.pip
    openssh
    rxvt_unicode
    slack
    source-code-pro
    stack
    unzip
    xclip
    vim
    zip
    zsh
  ];

  nixpkgs.config.allowUnfreePredicate =
    let
      unfreePkgs = [
        "slack"
        "corefonts"
      ];
      match = pkg: (prefix: pkgs.lib.hasPrefix (prefix + "-") pkg.name);
    in pkg: builtins.any (match pkg) unfreePkgs;

  programs = {
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
