{ config, lib, pkgs, ... }:

let
  cfg = config.services.postgresql;
in

with lib;

{
  config = mkIf cfg.enable {
    services.postgresql = {
      ensureDatabases = [ "sgillespie" ];

      ensureUsers = [
        {
          name = "sgillespie";
          ensureClauses.superuser = true;
        }
      ];

      dataDir = "/blockchain/postgresql/${config.services.postgresql.package.psqlSchema}";

      package = pkgs.postgresql_15;
    };

    environment.systemPackages = with pkgs; [
      pgcli
    ];
  };
}
