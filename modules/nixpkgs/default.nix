{ attrs, pkgs, ... }:

let
  inherit (pkgs) system;
in {
  nixpkgs = {
    overlays = [
      (import ../../overlays {
        feedback = attrs.feedback.packages.${system}.default;
        gibberish = attrs.gibberish.packages.${system}.default;
      })
    ];

    config = {
      android_sdk.accept_license = true;
      allowBroken = true; # TODO[sgillespie]
      allowUnfree = true;
    };
  };

  # Extra nix settings that should be globally enabled
  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
}
