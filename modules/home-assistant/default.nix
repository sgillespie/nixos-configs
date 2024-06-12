{ config, lib, pkgs, ... }:

let
  cfg = config.services.home-assistant;
in

with lib;

{
  config = mkIf cfg.enable {
    services = {
      home-assistant.config = {
        homeassistant = {
          name = "Home";
          http = {};
          openFirewall = true;
        };
      };

      dnsmasq = {
        enable = true;
        settings = {
          server = config.networking.nameservers;
          local-service = true;
          log-queries = true;
          bogus-priv = true;
          domain-needed = true;
        };
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [53];
        allowedUDPPorts = [53];
      };

      hosts = {
        "192.168.0.100" = [
          "home-assistant.local"
          "dnsmasq.local"
        ];
      };
    };
  };
}
