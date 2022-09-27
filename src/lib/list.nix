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
    concat
    const
    flip
    max
    min
    singleton
    sublist
  ;

  inherit (nix-alacarte)
    append
    compose
    equals
    notEquals
    notNull
    prepend
  ;

  inherit (nix-alacarte.internal)
    assert'
  ;

  foldStartingWithHead = scope:
    let
      assert'' = assert'.appendScope scope;
    in
    f: list:
      assert assert'' (list != [ ]) "empty list";
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

  headAndTails =
    let
      assert'' = assert'.appendScope "headAndTails";
    in
    list:
      assert assert'' (list != [ ]) "empty list";
      {
        head = head list;
        tail = tail list;
      };

  mapListToAttrs = f: list:
    listToAttrs (map f list);

  maximum = foldStartingWithHead "maximum" max;
  minimum = foldStartingWithHead "minimum" min;

  inherit (bootstrap)
    mergeListOfAttrs
  ;

  product = foldl' mul 1;

  appendElem = compose [ append singleton ];
  prependElem = compose [ prepend singleton ];

  removeNulls = filter notNull;

  replicate = n: val:
    genList (const val) n;

  splitAt = index: list: {
    left = sublist 0 index list;
    right = sublist index (length list - index) list;
  };

  sum = foldl' add 0;
}
