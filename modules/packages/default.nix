{ pkgs, ... }:

{
  environment.systemPackages =
      with pkgs; [
        android-tools
        autoconf
        automake
        bashInteractive
        binutils
        colmena
        cryptsetup
        curl
        docker-compose
        elinks
        elocrypt
        gcc
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
      ] ++ pkgs.lib.optionals (pkgs.system == "x86_64-linux") [
        gibberish
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
