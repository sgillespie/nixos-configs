{ config, lib, pkgs, ... }:

let
  cfg = config.services.postgresql;
in

with lib;

{
  config = mkIf cfg.enable {
    services.postgresql.ensureUsers = [
      {
        name = "sgillespie";
        ensureClauses.superuser = true;
      }
    ];

    environment.systemPackages = with pkgs; [
      pgcli
    ];
  };
}
