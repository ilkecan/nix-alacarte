{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    all
    filter
    foldl'
    genList
    head
    length
    listToAttrs
    tail
  ;

  inherit (lib)
    concat
    const
    recursiveUpdate
  ;

  inherit (nix-utils)
    equals
    notNull
  ;
in

{
  allEqual = list:
    all (equals (head list)) list;

  concatListOfLists = foldl' concat [ ];

  headAndTails = list:
    {
      head = head list;
      tail = tail list;
    };

  mapListToAttrs = f: list:
    listToAttrs (map f list);

  mergeListOfAttrs = foldl' recursiveUpdate { };

  removeNulls = filter notNull;

  replicate = n: val:
    genList (const val) n;
}
