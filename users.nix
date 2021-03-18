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
        "video"
      ];
    };

    sgillespie = {
      isNormalUser = true;
      extraGroups = [
        "bitcoin"
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
