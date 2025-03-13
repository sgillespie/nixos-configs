{ pkgs, ... }:

{
  environment.systemPackages =
      with pkgs; [
        autoconf
        automake
        bashInteractive
        binutils
        colmena
        cryptsetup
        curl
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
        nodejs_latest
        openssh
        openssl
        neovim
        neovim-remote
        patchelf
        parted
        pass
        python3
        unzip
        usbutils
        wget
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
    tmux.enable = true;
    zsh.enable = true;
    zsh.promptInit = "";
  };
}
