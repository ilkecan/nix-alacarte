{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    foldl'
    listToAttrs
  ;

  inherit (lib)
    concat
    mergeAttrs
  ;
in

{
  concatListOfLists = foldl' concat [ ];

  mapListToAttrs = f: list:
    listToAttrs (map f list);

  mergeListOfAttrs = foldl' mergeAttrs { };
}
