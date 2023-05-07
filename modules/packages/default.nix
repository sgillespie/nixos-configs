{ pkgs, ... }:

{
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
        cryptsetup
        curl
        docker-compose
        elinks
        elocrypt
        emacs
        gcc
        git-lfs
        gitAndTools.gitFull
        gnumake
        gnupg
        mutt-with-sidebar
        nodejs_latest
        openssh
        openssl
        patchelf
        parted
        pass
        python3
        sbt
        scala
        unzip
        usbutils
        vimHugeX
        vimPlugins.Syntastic
        yubikey-personalization
        zip
        zsh
      ];

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