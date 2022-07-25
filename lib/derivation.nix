{ lib, nix-utils }:

let
  inherit (nix-utils)
    mergeListOfAttrs
  ;
in

{
  overridePackageWith = pkg: overrides:
    pkg.override (mergeListOfAttrs overrides);
}
