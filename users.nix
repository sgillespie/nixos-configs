# User accounts
{ config, pkgs, ... }:

{
  users.extraUsers = {
    root.initialHashedPassword = "";

    agillespie = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "vboxusers"
      ];
    };

    sgillespie = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "vboxusers"
      ];
      shell = pkgs.zsh;
    };
  };
}
