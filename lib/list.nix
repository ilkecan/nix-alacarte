{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    filter
    foldl'
    head
    listToAttrs
    tail
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

  headAndTails = list:
    {
      head = head list;
      tail = tail list;
    };

  mapListToAttrs = f: list:
    listToAttrs (map f list);

  mergeListOfAttrs = foldl' mergeAttrs { };

  removeNulls = filter notNull;
}
