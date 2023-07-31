{ config, lib, pkgs, ... }:

let
  cfg = config.services.postgresql;
in

with lib;

{
  config = mkIf cfg.enable {
    services.postgresql = {
      ensureUsers = [
        {
          name = "sgillespie";
          ensureClauses.superuser = true;
        }
      ];

      dataDir = "/blockchain/postgresql/${config.services.postgresql.package.psqlSchema}";
    };

    environment.systemPackages = with pkgs; [
      pgcli
    ];
  };
}
