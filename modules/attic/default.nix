{ config, lib, pkgs, ... }:

let
  inherit (config.sops) secrets;
  cfg = config.services.atticd;
  sopsFile = ../../secrets/attic.yaml;
in

with lib;

{
  config = mkIf cfg.enable {
    services.atticd = {
      environmentFile = secrets."attic/environment".path;
      settings = {
        listen = "[::]:8001";
        jwt = { };
        chunking = {
          # The minimum NAR size to trigger chunking
          #
          # If 0, chunking is disabled entirely for newly-uploaded NARs.
          # If 1, all NARs are chunked.
          nar-size-threshold = 128 * 1024; # 128 KiB

          # The preferred minimum size of a chunk, in bytes
          min-size = 64 * 1024; # 64 KiB

          # The preferred average size of a chunk, in bytes
          avg-size = 128 * 1024; # 128 KiB

          # The preferred maximum size of a chunk, in bytes
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };

    users.extraUsers.atticd = {
      isSystemUser = true;
      group = "atticd";
    };
    users.groups.atticd = {};

    environment.systemPackages = with pkgs; [ attic-client attic-server ];

    sops.secrets = {
      "attic/environment" = {
        inherit sopsFile;
        owner = "atticd";
      };
    };
  };
}
