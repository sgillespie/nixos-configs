{ pkgs, ... }:

let
  emacsConfig = builtins.readFile ./config/emacs/init.el;
in {
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

      xdg.configFile = {
        "git".source = ./config/git;
        "kitty".source = ./config;
      };
    };
  };
}
