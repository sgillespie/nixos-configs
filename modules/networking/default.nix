{ config, pkgs, lib, ...}:
{
  networking = {
    networkmanager = {
      enable = lib.mkDefault true;
      unmanaged = ["interface-name:ve-*"];
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
    };
  };
}
