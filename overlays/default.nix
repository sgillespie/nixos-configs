{ feedback, gibberish, ... }:
self: super:

let
  inherit (super) callPackage haskell fetchFromGitHub;
  inherit (self) haskellPackages;
in

{
  inherit feedback gibberish;

  elocrypt = haskell.lib.dontCheck haskellPackages.elocrypt;

  i3blocks-contrib = with self.lib; self.stdenv.mkDerivation {
     pname = "i3blocks-contrib";
     version = "2.0.0";

     src = fetchFromGitHub {
       owner = "vivien";
       repo = "i3blocks-contrib";
       rev = "fc2c10551c32558be44226c6924d64bae611e32c";
       sha256 = "z7bLhDex8qCPBX73Umpg47VB4csxr2p6VMIyf/cjCdw=";
     };

     nativeBuildInputs = with self; [ pkg-config ];

     meta = {
       description = "Official repository for community contributed blocklets";
       homepage = "https://github.com/vivien/i3blocks-contrib";
       license = licenses.gpl3;
       platforms = with platforms; freebsd ++ linux;
     };
  };
}
