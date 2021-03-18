{ config, lib, pkgs, ... }:

let
  cfg = config.services.gaming;
in

with lib;

let
  kernelPackages = pkgs.linuxPackages_4_19;
  nixosGodot = fetchGit {
    url = "https://github.com/sgillespie/nixos-godot.git";
  };
in

rec {
  imports = [];

  options.services.gaming.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to include gaming support";
  };
  
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (import "${nixosGodot}/overlay.nix")
    ];
    
    hardware = {
      opengl.driSupport32Bit = true;
      pulseaudio.support32Bit = true;
    };

    # AMD GPU non-free
    # boot.kernelPackages = kernelPackages;
    # boot.extraModulePackages = [kernelPackages.amdgpu-pro];

    # Steam
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;

    # Unity
    environment.systemPackages = with pkgs; [
      blender
      godotMono
      pureref
      unityhub
    ];
  };
}
