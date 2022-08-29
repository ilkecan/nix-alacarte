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
    mul
    tail
  ;

  inherit (lib)
    assertMsg
    concat
    const
    flip
    max
    min
    sublist
  ;

  inherit (nix-utils)
    equals
    notNull
  ;

  foldStartingWithHead = f: list:
    assert assertMsg (list != [ ]) "nix-utils.minimum: empty list";
    let
      initial = head list;
    in
    foldl' f initial list;
in

{
  inherit (bootstrap)
    mergeListOfAttrs
  ;

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

  maximum = foldStartingWithHead max;
  minimum = foldStartingWithHead min;

  product = foldl' mul 1;

  removeNulls = filter notNull;

  replicate = n: val:
    genList (const val) n;

  splitAt = index: list: {
    left = sublist 0 index list;
    right = sublist index (length list - index) list;
  };

  sum = foldl' add 0;
}
