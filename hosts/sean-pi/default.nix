{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader = {
    grub.enable = false;
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking = {
    hostName = "sean-pi";
    defaultGateway = "192.168.1.254";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager.enable = lib.mkForce false;

    interfaces.enabcm6e4ei0.ipv4.addresses = [
      {
        address = "192.168.1.10";
        prefixLength = 24;
      }
    ];

    hosts = {
      "192.168.1.10" = [
        "dnsmasq.home"
        "pi.home"
        "home-assistant.mistersg.net"
        "mqtt.mistersg.net"
      ];

      "192.168.1.11" = [
        "pi-public.home"
        "nix-cache-local.mistersg.net"
      ];

      "192.168.0.109" = [
        "retropie.home"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    parted
    vim
    git
    wget
    zip
  ];

  hardware = {
    nvidia.enable = false;
    audio.enable = false;
  };

  programs = {
    haskell.enable = false;
  };

  services = {
    ai.enable = false;
    atticd.enable = false;
    cardano-node.enable = false;
    home-assistant.enable = true;
    hydra.enable = false;
    minecraft-bedrock-server.enable = false;
    ntp.enable = true;
    postgresql.enable = false;
    virtualisation.enable = false;
    xserver.enable = false;
    yubikey.enable = false;

    lan = {
      enable = true;
      dhcpStart = "192.168.1.100";
      dhcpEnd = "192.168.1.200";
      listenAddresses = [ "192.168.1.10" ];
    };
  };

  sops.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
