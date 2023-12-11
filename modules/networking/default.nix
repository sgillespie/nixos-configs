{ config, pkgs, ...}:
{
  networking = {
    networkmanager = {
      enable = true;
      unmanaged = ["interface-name:ve-*"];
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
    };
  };
}
