{ pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.sgillespie = {
      home.stateVersion = "23.11";

      home.file = {
        ".gitconfig".source = ./gitconfig;
      };

      xdg.configFile = {
        "kitty/kitty.conf".source = ./kitty.conf;
        "git/iohk.inc".source = ./gitconfig-iohk;
        "git/hooks/pre-push".source = ./pre-push;
      };
    };
  };
}
