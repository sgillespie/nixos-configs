# Docker/VMs
{ config, pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };

    virtualbox.host.enable = true;
  };
}
