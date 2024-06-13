{ config, lib, pkgs, ... }:

let
  cfg = config.services.home-assistant;
in

with lib;

{
  config = mkIf cfg.enable {
    services = {
      home-assistant = {
        extraComponents = [
          # Components required to complete the onboarding
          "esphome"
          "met"
          "radio_browser"

          # Zigbee
          "zha"
        ];

        config = {
          default_config = {};

          homeassistant = {
            name = "Home";
          };

          http = {
            server_host = "::1";
            trusted_proxies = [ "::1" ];
            use_x_forwarded_for = true;
          };
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

      nginx = {
        enable = true;
        recommendedProxySettings = false;

        virtualHosts."home-assistant.mistersg.net" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          extraConfig = ''
            proxy_buffering off;
          '';

          locations."/" = {
            proxyPass = "http://[::1]:8123";
            proxyWebsockets = true;
          };
        };
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [53 80 443];
        allowedUDPPorts = [53 80 443];
      };

      hosts = {
        "192.168.0.100" = [
          "home-assistant.mistersg.net"
          "dnsmasq.local"
        ];
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "sean@misters.net";
        dnsProvider = "dreamhost";
        environmentFile = "/var/lib/secrets/certs.secret";
      };
    };
  };
}
