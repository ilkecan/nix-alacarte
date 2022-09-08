{
  bootstrap,
  lib,
  nix-alacarte,
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

  inherit (nix-alacarte)
    equals
    notEquals
    notNull
  ;

  foldStartingWithHead = f: list:
    assert assertMsg (list != [ ]) "nix-alacarte.minimum: empty list";
    let
      initial = head list;
    in
    foldl' f initial list;
in

{
  allEqual = list:
    all (equals (head list)) list;

  append = flip concat;
  prepend = concat;

  empty = equals [ ];
  notEmpty = notEquals [ ];

  headAndTails = list:
    {
      head = head list;
      tail = tail list;
    };

  mapListToAttrs = f: list:
    listToAttrs (map f list);

  maximum = foldStartingWithHead max;
  minimum = foldStartingWithHead min;

  inherit (bootstrap)
    mergeListOfAttrs
  ;

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
