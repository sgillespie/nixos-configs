# Packages/programs configuration
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    let
      mypkgs = import ./mypkgs {
        inherit (pkgs) pkgs;
      };

      inherit (mypkgs) elocrypt;

      androidPlatformTools = pkgs.androidenv.androidPkgs_9_0.platform-tools;
    in
      with pkgs; [
        alsaUtils
        androidPlatformTools
        autoconf
        automake
        bashInteractive
        binutils
        cabal-install
        chromium
        cryptsetup
        curl
        docker_compose
        elinks
        elocrypt
        emacs
        feh
        firefox
        gcc
        ghc
        gitAndTools.gitFull
        gnumake
        gnupg
        irssi
        mutt-with-sidebar
        nodejs
        openssh
        patchelf
        parted
        pass
        python27Packages.pywatchman
        rxvt_unicode
        sbt
        scala
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
        virtualbox
        watchman
        zip
        zsh
      ];

  nixpkgs.config = {
    android_sdk.accept_license = true;

    allowUnfreePredicate =
      let
        unfreePkgs = [
          "slack"
          "corefonts"
          "spotify"
        ];
        match = pkg: (prefix: pkgs.lib.hasPrefix (prefix + "-") pkg.name);
      in
        pkg: builtins.any (match pkg) unfreePkgs;
  };

  programs = {
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
