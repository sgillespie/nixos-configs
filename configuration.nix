# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix       # install system packages
      ./xserver.nix        # x.org configuration
      ./users.nix          # user accounts
      ./virtualisation.nix # docker and VMs
    ];

  # Use the grub EFI boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = false;
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

    networkmanager = {
      enable = true;
      unmanaged = ["interface-name:ve-*"];
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "wlp7s0";
    };
  };

  services = {
    udev.packages = with pkgs; [
      libu2f-host
      yubikey-personalization
    ];

    pcscd.enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    # Not yet
    # consoleUseXkbConfig = true;  # Copy from xkbOptions
    defaultLocale = "en_US.UTF-8";
  };

  hardware.pulseaudio.enable = true;

  security = {
    pam.u2f = {
      enable = true;
      control = "required";
      cue = true;
    };
    
    sudo.wheelNeedsPassword = false;
  };

  time.timeZone = "America/New_York";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
