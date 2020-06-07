{ config, pkgs, ... }:

{
  nixpkgs = {
    overlays = [
      (import ./nixos-rocm)
    ];

    config.rocmTargets = ["gfx803"];
  };

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [pkgs.rocm-opencl-icd];
}
