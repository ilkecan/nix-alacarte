{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    filter
    foldl'
    listToAttrs
  ;

  inherit (lib)
    concat
    mergeAttrs
  ;

  inherit (nix-utils)
    notNull
  ;
in

{
  concatListOfLists = foldl' concat [ ];

  mapListToAttrs = f: list:
    listToAttrs (map f list);

  mergeListOfAttrs = foldl' mergeAttrs { };

  removeNulls = filter notNull;
}
