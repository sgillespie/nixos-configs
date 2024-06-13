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

        virtualHosts."home-assistant.local" = {
          forceSSL = true;
          enableACME = true;
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
          "home-assistant.local"
          "dnsmasq.local"
        ];
      };
    };

    security.acme = {
      acceptTerms = true;
      # TODO: Currently I'm only doing this to automatically create a self-signed
      # certificate, but eventually I'd like signed certificate
      defaults.email = "admin+acme@local";
    };
  };
}
