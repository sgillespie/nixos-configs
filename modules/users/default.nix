{ pkgs, ... }:

{
  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  nix.settings = {
    trusted-users = ["root" "@wheel"];
  };

  users.extraUsers = {
    root.initialHashedPassword = "";

    agillespie = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "vboxusers"
        "video"
      ];
    };

    sgillespie = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "vboxusers"
        "video"
      ];
      shell = pkgs.zsh;
    };
  };
}
