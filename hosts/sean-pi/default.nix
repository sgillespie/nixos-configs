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
    networkmanager.enable = lib.mkForce false;

    hosts = {
      "192.168.0.100" = [
        "pi.local"
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
  };

  sops.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

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
