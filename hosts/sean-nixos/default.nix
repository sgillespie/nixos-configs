{ config, pkgs, ... }:

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
    firewall.enable = true;
    hostName = "sean-nixos";
    
    networkmanager = {
      enable = false; # TODO[sgillespie]
      unmanaged = ["interface-name:ve-*"];
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  nixpkgs.config = pkgs.config;

  hardware = {
    enableAllFirmware = true;
    nvidiaUnfree.enable = true;
    pulseaudio.enable = false;
  };

  services = {
    yubikey.enable = true;
    ntp.enable = true;
  };

  programs.wayland.enable = true;
  
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

