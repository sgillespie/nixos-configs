{ pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.sgillespie = {
      home.stateVersion = "23.11";

      xdg.configFile = {
        "git".source = ./config/git;
        "kitty".source = ./config;
      };
    };
  };
}
