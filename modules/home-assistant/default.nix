{ config, lib, pkgs, ... }:

let
  cfg = config.services.home-assistant;
in

with lib;

{
  config = mkIf cfg.enable {
  };
}
