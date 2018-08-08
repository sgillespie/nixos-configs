{ nixpkgs ? import <nixpkgs> {} }:

let
  inherit (nixpkgs) pkgs;
in
  {
    ghcDev = import ./ghc-dev.nix;

    # Override latest version
    androidPlatformTools = pkgs.lib.overrideDerivation pkgs.androidenv.platformTools
    (drv: rec {
      name = "android-platform-tools-r${version}";
      version = "28.0.0";
      src = pkgs.fetchurl {
        url = "https://dl.google.com/android/repository/platform-tools_r${version}-linux.zip";
        sha256 = "05mvig7zhl254bc0aq9rf1ka33xvqslmcj9n6n1rw3ygapj0lf9m";
      };
    });

    # Elocrypt integration tests don't pass on Nix
    elocrypt = pkgs.haskell.lib.dontCheck pkgs.haskellPackages.elocrypt; 
}
