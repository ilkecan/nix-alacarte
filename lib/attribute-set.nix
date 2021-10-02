{ lib, nix-utils }:

let
  inherit (builtins)
    mapAttrs
  ;
  inherit (lib)
  ;
  inherit (nix-utils)
  ;
in

rec {
  forEachAttr = set: f:
    mapAttrs f set;
}
