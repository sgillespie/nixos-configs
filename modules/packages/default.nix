{ pkgs, ... }:

{
  environment.systemPackages =
      with pkgs; [
        attic-client
        autoconf
        automake
        bashInteractive
        binutils
        colmena
        cryptsetup
        curl
        dig
        dnsutils
        elocrypt
        file
        gcc
        git
        gnumake
        gnupg
        iamb
        jq
        lsof
        openssh
        openssl
        neovim
        neovim-remote
        patchelf
        parted
        pass
        pciutils
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
