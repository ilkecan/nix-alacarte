{
  lib,
  nix-utils,
  bootstrap,
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
  inherit (bootstrap) mergeListOfAttrs;

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

  removeNulls = filter notNull;

  replicate = n: val:
    genList (const val) n;
}
