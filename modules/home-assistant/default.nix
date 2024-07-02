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

          # MQTT
          "mqtt"
        ];

        config = {
          default_config = {};

          homeassistant = {
            name = "Home";
          };

          "automation manual"  = [];
          "automation ui" = "!include automations.yaml";

          http = {
            server_host = "::1";
            trusted_proxies = [ "::1" ];
            use_x_forwarded_for = true;
          };

          alarm_control_panel = {
            platform = "manual";
            name = "Security Alarm";
            code = "!secret control_panel_code";
            code_arm_required = false;

            armed_home = {
              delay_time = 0;
              arming_time = 0;
            };

            armed_away = {
              delay_time = 120;
              arming_time = 120;
            };
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

      mosquitto = {
        enable = true;
        listeners = [
          {
            users.zigbee2mqtt = {
              acl = [ "readwrite #" ];
              hashedPasswordFile = /etc/mosquitto/passwd;
            };
          }
        ];
      };

      nginx = {
        enable = true;
        recommendedProxySettings = false;

        virtualHosts = {
          "home-assistant.mistersg.net" = {
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

          "mqtt.mistersg.net" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            basicAuthFile = /etc/nginx/z2m.htpasswd;

            locations."/" = {
              proxyPass = "http://[::1]:8080";
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };
          };
        };
      };

      zigbee2mqtt = {
        enable = true;
        settings = {
          mqtt = {
            user = "!secret.yaml user";
            password = "!secret.yaml password";
          };

          permit_join = false;

          homeassistant = {
            legacy_entity_attributes = false;
            legacy_triggers = false;
          };

          serial = {
            port = "/dev/ttyACM0";
          };

          frontend = {
            port = 8080;
            url = "https://zigbee2mqtt.mistersg.net";
          };

          advanced = {
            channel = 20;
            ext_pan_id = [ 195 20 220 117 23 145 33 126 ];
            network_key = [ 34 209 12 177 145 106 82 85 90 221 6 230 86 32 47 167 ];
            pan_id = 25316;
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
          "mqtt.mistersg.net"
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
