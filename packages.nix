# Packages/programs configuration
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    curl
    docker
    docker_compose
    elinks
    emacs
    feh
    firefox
    gitAndTools.gitFull
    openssh
    rxvt_unicode
    source-code-pro
    unzip
    xclip
    vim
    zip
    zsh
  ];

  programs = {
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };
}
