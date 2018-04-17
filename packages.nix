# Packages/programs configuration
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bashInteractive
    binutils
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

  nixpkgs.config.allowUnfreePredicate = (x: pkgs.lib.hasPrefix "slack-" x.name);

  programs = {
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
