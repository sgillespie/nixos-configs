{ pkgs, ... }:

let
  emacsConfig = builtins.readFile ./config/emacs/default.el;
in {
  environment.systemPackages = with pkgs; [ pre-commit ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.sgillespie = {
      home.stateVersion = "23.11";

      # Use home-manager's emacs puts the config file in default.el, rather than .emacs,
      # which will allow emacs to write to its init file
      programs.emacs = {
        enable = true;
        extraConfig = emacsConfig;
      };

      home.file = {
        ".bashrc".source = ./config/bash/bashrc;
        ".zshrc".source = ./config/zsh/zshrc;
        ".local/libexec/i3blocks".source = "${pkgs.i3blocks-contrib}/libexec/i3blocks";
        ".xinitrc".source = ./config/startx/xinitrc;
      };

      xdg.configFile = {
        "agda".source = ./config/agda;
        "bash".source = ./config/bash;
        "git".source = ./config/git;
        "i3".source = ./config/i3;
        "i3blocks".source = ./config/i3blocks;
        "iamb".source = ./config/iamb;
        "kitty".source = ./config/kitty;
        "nvim".source = ./config/nvim;
        "tmux".source = ./config/tmux;
        "zsh".source = ./config/zsh;
        "i3blocks-contrib".source = pkgs.i3blocks-contrib;
        "Yubico".source = ./config/Yubico;
      };
    };
  };
}
