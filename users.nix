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
      ];
    };

    sgillespie = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
    };
  };
}
