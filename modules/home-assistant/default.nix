{ config, lib, pkgs, ... }:

let
  inherit (config.sops) secrets;
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

          # Allow automations created in the UI and in config
          "automation manual"  = [];
          "automation ui" = "!include automations.yaml";

          # Enable proxying from nginx
          http = {
            server_host = "::1";
            trusted_proxies = [ "::1" ];
            use_x_forwarded_for = true;
          };

          # Create an alarm panel--can only be created in config
          alarm_control_panel = {
            name = "Security Alarm";
            # This is a software control panel
            platform = "manual";
            # This code is stored in secrets.yaml (defined below)
            code = "!secret control_panel_code";
            # Allow arming the alarm without entering a code
            code_arm_required = false;

            armed_home = {
              # We're not leaving, so arm immediately
              arming_time = 0;
              # Trigger the alarm immediately
              delay_time = 0;
            };

            armed_away = {
              # Give me 2 minutes to leave after arming the alarm
              arming_time = 120;
              # Give me 2 minutes to run inside and disarm
              delay_time = 120;
            };
          };
        };
      };

      # Local DNS server. This is how we get lets encrypt certificates for
      # mistersg.net (defined below)
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

      # MQTT server--Used for Zigbee<->Home Assistant communication
      mosquitto = {
        enable = true;
        listeners = [
          {
            users.zigbee2mqtt = {
              # This server only for zigbee, so there are no restrictions on which topics
              # it can write too
              acl = [ "readwrite #" ];
              hashedPasswordFile = secrets."mosquitto/hashedPassword".path;
            };
          }
        ];
      };

      # A reverse proxy for all services exposed to the internal network
      nginx = {
        enable = true;
        # recommendedProxySettings breaks Home Assistant for some reason
        recommendedProxySettings = false;

        virtualHosts = {
          # Proxy to home assistant. Since this is the first, it's also the default
          "home-assistant.mistersg.net" = {
            # Generate lets encrypt certificate using DNS challenge
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

          # Zigbee2MQTT frontend
          "mqtt.mistersg.net" = {
            # Generate lets encrypt certificate using DNS challenge
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            # The frontend grants full power to the zigbee network, but doesn't offer any
            # protection.
            basicAuthFile = secrets."nginx/zigbee2mqtt/basicAuth".path;

            locations."/" = {
              proxyPass = "http://[::1]:8080";
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };
          };
        };
      };

      # Zigbee network
      zigbee2mqtt = {
        enable = true;

        settings = {
          mqtt = {
            user = "!secret.yaml user";
            password = "!secret.yaml password";
          };

          # Don't let devices join all the time. This can be temporarily overridden in
          # Home Assistant or Zigbee2MQTT frontend.
          permit_join = false;

          homeassistant = {
            legacy_entity_attributes = false;
            # MQTT device triggers are better
            legacy_triggers = false;
          };

          # The zigbee hardware dongle
          serial = {
            port = "/dev/ttyACM0";
          };

          # Enable the web frontend. Proxied with nginx above
          frontend = {
            port = 8080;
            url = "https://zigbee2mqtt.mistersg.net";
          };

          # Zigbee network parameters. Defined here so it's not regenerated every reboot
          advanced = {
            channel = 20;
            ext_pan_id = [ 195 20 220 117 23 145 33 126 ];
            pan_id = 25316;

            # Network encryption key
            network_key = "!secret.yaml network_key";
          };
        };
      };
    };

    networking = {
      # Expose DNS and HTTP
      firewall = {
        allowedTCPPorts = [53 80 443];
        allowedUDPPorts = [53 80 443];
      };

      # Virtual hosts for local DNS
      hosts = {
        "192.168.0.100" = [
          "home-assistant.mistersg.net"
          "mqtt.mistersg.net"
          "dnsmasq.local"
        ];
      };
    };

    # Lets encrypt certificates
    security.acme = {
      acceptTerms = true;

      # DNS challenge
      defaults = {
        email = "sean@misters.net";
        dnsProvider = "dreamhost";
        environmentFile = secrets."letsEncrypt/environment".path;
      };
    };

    # Secrets required for this module
    sops.secrets =
      let
        sopsFile = ../../secrets/home-assistant.yaml;
      in {
        "homeAssistant/secrets.yaml" = {
          inherit sopsFile;
          owner = "hass";
          path = "/var/lib/hass/secrets.yaml";
        };

        "letsEncrypt/environment" = {
          inherit sopsFile;
          owner = "acme";
        };

        "mosquitto/hashedPassword" = {
          inherit sopsFile;
          owner = "mosquitto";
        };

        "nginx/zigbee2mqtt/basicAuth" = {
          inherit sopsFile;
          owner = config.services.nginx.user;
        };

        "zigbee2mqtt/secret.yaml" = {
          inherit sopsFile;
          owner = "zigbee2mqtt";
          path = "/var/lib/zigbee2mqtt/secret.yaml";
        };
      };
  };
}
