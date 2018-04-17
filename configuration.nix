# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix    # install system packages
      ./xserver.nix     # x.org configuration
      ./users.nix       # user accounts
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    # boot.loader.systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
      device = "nodev";
      efiSupport = true;
      enable = true;
      useOSProber = true;
    };
  };

  networking = {
    firewall.enable = true;
    hostName = "sean-nixos";
    networkmanager.enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  hardware.pulseaudio.enable = true;
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "America/New_York";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
