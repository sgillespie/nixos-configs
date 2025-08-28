{ config, pkgs, lib, ...}:

let
  inherit (config.networking) networkmanager;
  lan = config.services.lan;
in

with lib;

{
  options.services.lan = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable a local DNS and DHCP server.";
    };

    dhcpStart = mkOption {
      type = types.string;
      default = "192.168.1.100";
      description = "The beginning range of DHCP addresses";
    };

    dhcpEnd = mkOption {
      type = types.string;
      default = "192.168.1.200";
      description = "The ending range of DHCP addresses";
    };

    listenAddresses = mkOption {
      type = types.listOf types.string;
      default = [];
      description = "IP address to bind the DNS and DHCP servers to";
    };
  };

  config = {
    networking = {
      networkmanager = {
        enable = mkDefault true;
        dns = mkDefault (if networkmanager.enable then "systemd-resolved" else "default");
      };

      firewall = mkIf lan.enable {
        allowedUDPPorts = [ 53 67 68 ];
        allowedTCPPorts = [ 53 ];  
      };
    };

    services = {
      resolved.enable = mkDefault networkmanager.enable;

      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };

      # Local DNS/DHCP server.
      dnsmasq = mkIf lan.enable {
        enable = true;

        settings = {
          # DNS Settings
          bogus-priv = true;
          cache-size = 5000;
          dhcp-authoritative = true;
          domain-needed = true;
          min-cache-ttl = 60;
          no-resolv = true;
          server = config.networking.nameservers;
          listen-address = [ 
            "127.0.0.1"
          ] ++ lan.listenAddresses; 

          # DHCP
          enable-ra = true;

          dhcp-option = [
            "option:router,${config.networking.defaultGateway.address}"
          ];

          dhcp-range = [
            # Range of IPv4 addresses to give out
            "${lan.dhcpStart},${lan.dhcpEnd},24h"
          ];
        };
      };
    };
  };
}
