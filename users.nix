# User accounts
{ config, pkgs, ... }:

{
  users.extraUsers = {
    agillespie = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };

    sgillespie = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
      shell = pkgs.zsh;
    };
  };
}
