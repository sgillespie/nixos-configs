{ feedback }:
self: super:

let
  inherit (super) callPackage haskell fetchFromGitHub;
  inherit (self) haskellPackages;
in

{
  inherit feedback;

  elocrypt = haskell.lib.dontCheck haskellPackages.elocrypt;
}
