{
  bootstrap,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    add
    elemAt
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
    pipe
    flip
    range
    max
    min
    singleton
    sublist
  ;

  inherit (nix-alacarte)
    append
    compose
    decrement
    empty
    equalTo
    findIndices
    notEqualTo
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
    all (equalTo (head list)) list;

  append = flip concat;
  prepend = concat;

  empty = equalTo [ ];
  notEmpty = notEqualTo [ ];

  findIndex = predicate: list:
    let
      indices = findIndices predicate list;
    in
    if empty indices then null else head indices; 

  findIndices = predicate: list:
    pipe list [
      length
      decrement
      (range 0)
      (filter (i: predicate (elemAt list i)))
    ];

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
