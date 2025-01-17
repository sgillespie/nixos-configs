{ pkgs, ... }:

{
  environment.systemPackages =
      with pkgs; [
        android-tools
        autoconf
        automake
        bashInteractive
        binutils
        cryptsetup
        curl
        docker-compose
        elinks
        elocrypt
        gcc
        gibberish
        git-lfs
        gitAndTools.gitFull
        gnumake
        gnupg
        iamb
        irssi
        jq
        mutt-with-sidebar
        nodejs_latest
        openssh
        openssl
        patchelf
        parted
        pass
        python3
        unzip
        usbutils
        vimHugeX
        vimPlugins.Syntastic
        wget
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
    browserpass.enable = true;
    chromium.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
