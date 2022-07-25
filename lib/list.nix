{ lib, nix-utils }:

let
  inherit (builtins)
    foldl'
  ;

  inherit (lib)
    mergeAttrs
  ;

  inherit (nix-utils)
    mergeListOfAttrs
  ;
in

{
  mapListToAttrs = f: list:
    mergeListOfAttrs (map f list);

  mergeListOfAttrs = foldl' mergeAttrs { };
}
