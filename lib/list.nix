{ lib, nix-utils }:

let
  inherit (builtins)
    foldl'
  ;

  inherit (lib)
    concat
    mergeAttrs
  ;

  inherit (nix-utils)
    mergeListOfAttrs
  ;
in

{
  concatListOfLists = foldl' concat [ ];

  mapListToAttrs = f: list:
    mergeListOfAttrs (map f list);

  mergeListOfAttrs = foldl' mergeAttrs { };
}
