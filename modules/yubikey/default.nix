{ config, lib, pkgs, ... }:


let
  cfg = config.services.yubikey;
in

with lib;

{
  options.services.yubikey.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable PAM yubikey support";
  };

  config = mkIf cfg.enable {
    security.pam = {
      u2f.control = "required";

      services = {
        login.u2fAuth = true;
      };
    };
  };
}