# Packages/programs configuration
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    let
      androidPlatformTools = pkgs.androidenv.androidPkgs_9_0.platform-tools;
    in
      with pkgs; [
        alsaUtils
        androidPlatformTools
        autoconf
        automake
        bashInteractive
        binutils
        chromium
        clipmenu
        cryptsetup
        curl
        docker_compose
        elinks
        elocrypt
        emacs
        feh
        firefox
        gcc
        gitAndTools.gitFull
        gnumake
        gnupg
        irssi
        mutt-with-sidebar
        nodejs_latest
        openssh
        openssl
        patchelf
        parted
        pass
        passff-host
        python27Packages.pywatchman
        python3
        rofi
        rxvt_unicode
        sbt
        scala
        scrot
        slack
        spotify
        source-code-pro
        tdesktop
        unzip
        usbutils
        xclip
        xdotool
        vimHugeX
        vimPlugins.Syntastic
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
    java = {
      enable = true;
      package = pkgs.adoptopenjdk-bin;
    };
    ssh.startAgent = false;

    browserpass.enable = true;
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
