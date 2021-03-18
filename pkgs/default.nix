self: super:

let
  inherit (super) callPackage haskell fetchFromGitHub;
  inherit (self) haskellPackages;
in

{
  blender = callPackage ./blender {
    blender = super.blender;
  };
  elocrypt = haskell.lib.dontCheck haskellPackages.elocrypt;
  openimageio2 = callPackage ./openimageio2 {
    openimageio2 = super.openimageio2;
  };
  pureref = callPackage ./pureref { };
  unityhub = callPackage ./unityhub { };
}
