self: super:

let
  inherit (super) callPackage haskell fetchFromGitHub;
  inherit (self) haskellPackages;
in

{
  elocrypt = haskell.lib.dontCheck haskellPackages.elocrypt;
}