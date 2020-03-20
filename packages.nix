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
        openssl
        patchelf
        parted
        pass
        passff-host
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
        yubikey-personalization
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
      in
        pkg: builtins.elem (pkgs.lib.getName pkg) unfreePkgs;
  };

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ssh.startAgent = false;

    browserpass.enable = true;
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
