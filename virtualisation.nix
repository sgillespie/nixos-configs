# Docker/VMs
{ config, pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };

    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
    };

    virtualbox.host.enable = true;
  };
}
