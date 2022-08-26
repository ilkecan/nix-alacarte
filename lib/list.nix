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
    genList
    head
    length
    listToAttrs
    tail
  ;

  inherit (lib)
    const
    sublist
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

  splitAt = index: list: {
    left = sublist 0 index list;
    right = sublist index (length list - index) list;
  };
}
