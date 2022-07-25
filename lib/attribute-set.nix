{ lib, nix-utils }:

let
  inherit (builtins)
    mapAttrs
  ;
in

{
  forEachAttr = set: f:
    mapAttrs f set;
}
