{ config, lib, pkgs, ... }:

let
  inherit (config.sops) secrets;

  cfg = config.services.caldav;
  sopsFile = ../../secrets/caldav.yaml;
in

with lib;

{
  options.services.caldav.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable CalDAV server";
  };

  config = mkIf cfg.enable {
    services = {
      radicale = {
        enable = true;
        settings.auth.type = "none";
      };

      davis = {
        enable = true;
        adminLogin = "admin";
        adminPasswordFile = secrets."davis/admin_password".path;
        appSecretFile = secrets."davis/app_secret".path;
        hostname = "calendar.mistersg.net";

        mail = {
          dsnFile = secrets."davis/email_dsn".path;
          inviteFromAddress = "sean@mistersg.net";
        };

        # The NixOS Davis module seems to be inserting this:
        #
        #     LOG_FILE_PATH="/dev/stdout"
        #
        # and there's no service for it to write a journal in. Overwrite that with an 
        # explicit log file
        config.LOG_FILE_PATH = mkForce "/var/lib/davis/var/log/davis.log";

        nginx = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
        };
      };
    };

    sops.secrets = {
      "davis/admin_password" = {
        inherit sopsFile;
        owner = "davis";
      };

      "davis/app_secret" = {
        inherit sopsFile;
        owner = "davis";
      };

      "davis/email_dsn" = {
        inherit sopsFile;
        owner = "davis";
      };
    };
  };
}
