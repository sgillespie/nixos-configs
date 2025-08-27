{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_1;

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

  networking = {
    hostName = "sean-nixos";
    networkmanager.enable = lib.mkForce false;
  };

  hardware = {
    nvidia.enable = true;
    audio.enable = true;
  };

  services = {
    ai.enable = true;
    minecraft-bedrock-server.enable = false;
    yubikey.enable = true;
    ntp.enable = true;
    postgresql.enable = true;
    cardano-node.enable = true;
    hydra.enable = false;
    virtualisation.enable = true;
    xserver.enable = true;
  };

  programs = {
    haskell.enable = true;
    retroarch.enable = true;
    wayland.enable = false;
  };
  sops.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
