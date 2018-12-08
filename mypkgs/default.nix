{ pkgs }: 

let
  inherit (pkgs) androidenv fetchurl haskell haskellPackages lib;
in
  rec {
    ghcDev = import ./ghc-dev.nix;

    # Override latest version
    androidPlatformTools = lib.overrideDerivation androidenv.platformTools
      (drv: rec {
        name = "android-platform-tools-r${version}";
        version = "28.0.0";
        src = fetchurl {
          url = "https://dl.google.com/android/repository/platform-tools_r${version}-linux.zip";
          sha256 = "05mvig7zhl254bc0aq9rf1ka33xvqslmcj9n6n1rw3ygapj0lf9m";
        };
      });

    # Elocrypt integration tests don't pass on Nix
    elocrypt = haskell.lib.dontCheck haskellPackages.elocrypt; 
  }
