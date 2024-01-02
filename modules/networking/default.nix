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

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
}
