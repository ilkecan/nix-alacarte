{
  lib,
  nix-utils,
  bootstrap,
  ...
}:

let
  inherit (builtins)
    add
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
    flip
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

  append = concat;
  prepend = flip concat;

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

  sum = foldl' add 0;
}
