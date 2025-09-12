{ config, lib, pkgs, nixos-raspberrypi, ... }:

{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.display-vc4
    raspberry-pi-5.bluetooth

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "sean-pi-public";
    networkmanager.enable = lib.mkForce false;
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.10" ]; # sean-pi

    interfaces.end0.ipv4.addresses = [
      # Network-local names will be bound here
      {
        address = "192.168.1.11";
        prefixLength = 24;
      }

      # Public DNS records will be forwarded here
      {
        address = "192.168.1.12";
        prefixLength = 24;
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    parted
    vim
    wget
    zip
  ];

  hardware = {
    # nvidia.enable = false;
    audio.enable = false;
  };

  programs = {
    haskell.enable = false;
  };

  services = {
    ai.enable = false;
    atticd.enable = true;
    cardano-node.enable = false;
    home-assistant.enable = false;
    hydra.enable = false;
    minecraft-bedrock-server.enable = false;
    ntp.enable = true;
    postgresql.enable = false;
    virtualisation.enable = false;
    xserver.enable = false;
    yubikey.enable = false;
    lan.enable = false;
  };

  sops.enable = true;

  system.nixos.tags = 
    let
      cfg = config.boot.loader.raspberryPi;
    in [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];

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
  system.stateVersion = "25.05"; # Did you read the comment?
}
