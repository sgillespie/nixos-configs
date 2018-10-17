# Packages/programs configuration
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    let
      mypkgs = import ./mypkgs { nixpkgs = pkgs; };
      inherit (mypkgs) elocrypt androidPlatformTools;
    in
      with pkgs; [
        androidPlatformTools
        alsaUtils
        autoconf
        automake
        bashInteractive
        binutils
        cabal-install
        chromium
        curl
        docker_compose
        elinks
        elocrypt
        emacs
        feh
        firefox
        gcc
        gnumake
        gnupg
        ghc
        gitAndTools.gitFull
        irssi
        mutt-with-sidebar
        openssh
        rxvt_unicode
        scrot
        slack
        spotify
        source-code-pro
        stack
        thunderbird
        unzip
        usbutils
        xclip
        vimHugeX
        vimPlugins.Syntastic
        zip
        zsh
      ];

  nixpkgs.config.allowUnfreePredicate =
    let
      unfreePkgs = [
        "slack"
        "corefonts"
        "spotify"
      ];
      match = pkg: (prefix: pkgs.lib.hasPrefix (prefix + "-") pkg.name);
    in
      pkg: builtins.any (match pkg) unfreePkgs;

  programs = {
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
