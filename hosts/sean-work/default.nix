{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_1;
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    loader = {
      grub = {
        efiSupport = true;
        enable = true;
        device = "nodev";
        useOSProber = true;
      };

      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "sean-work";

  hardware = {
    system76 = {
      enableAll = true;
      power-daemon.enable = true;
    };

    nvidia.enable = true;
    audio.enable = true;
  };

  specialisation."mobile".configuration = {
    system.nixos.tags = [ "mobile" ];
    hardware.nvidia.enable = pkgs.lib.mkForce false;
    services.cardano-node.enable = pkgs.lib.mkForce false;
  };

  environment.systemPackages = [pkgs.acpi];

  services = {
    atticd.enable = true;
    logind.lidSwitchExternalPower = "ignore";
    yubikey.enable = true;
    ntp.enable = true;
    postgresql.enable = true;
    cardano-node.enable = true;
    hydra.enable = false;
    virtualisation.enable = true;
    xserver.enable = true;
  };

  sops.enable = true;

  programs = { 
    haskell.enable = true;
    wayland.enable = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
