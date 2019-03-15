let
  pinned = import ./nixpkgs.nix;

in

  { pkgs ? import pinned {}
  , compiler ? "ghc843"
  }:

  pkgs.haskell.packages.${compiler}.callPackage ./minimal.nix { }
