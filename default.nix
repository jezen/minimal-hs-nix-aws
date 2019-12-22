let
  pinned = import ./nix/nixpkgs.nix;

in

  { pkgs ? import pinned {}
  , compiler ? "ghc865"
  }:

  pkgs.haskell.packages.${compiler}.callPackage ./minimal.nix { }
