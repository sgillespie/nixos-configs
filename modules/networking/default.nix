{ config, pkgs, lib, ...}:
{
  networking = {
    networkmanager = {
      enable = lib.mkDefault true;
      dns = "systemd-resolved";
      unmanaged = ["interface-name:ve-*"];
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
    };
  };

  services.resolved.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
}
