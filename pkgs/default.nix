self: super:

let
  inherit (super) haskell haskellPackages;
in

{
  elocrypt = haskell.lib.dontCheck haskellPackages.elocrypt; 
}
