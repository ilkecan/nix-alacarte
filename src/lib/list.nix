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
    elemAt
    filter
    foldl'
    partition
    genList
    head
    isAttrs
    length
    listToAttrs
    mul
    tail
  ;

  inherit (lib)
    concat
    const
    findFirst
    flip
    id
    imap0
    max
    min
    pipe
    singleton
    sublist
  ;

  inherit (nix-alacarte)
    append
    compose
    empty
    equalTo
    findIndex
    findIndices
    indexed
    negative
    notEqualTo
    notNull
    pair
    pipe'
    prepend
    range'
    snd
    uncurry
  ;

  inherit (nix-alacarte.internal)
    assertion
  ;

  foldStartingWithHead = scope:
    let
      assertion' = assertion.appendScope scope;
    in
    f: list:
      assert assertion' (list != [ ]) "empty list";
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

  appendElem = compose [ append singleton ];
  prependElem = compose [ prepend singleton ];

  elemIndex = compose [ findIndex equalTo ];
  elemIndices = compose [ findIndices equalTo ];

  empty = equalTo [ ];
  notEmpty = notEqualTo [ ];

  find = pred:
    findFirst pred null;

  findIndex = predicate: list:
    let
      indices = findIndices predicate list;
    in
    if empty indices then null else head indices; 

  findIndices = predicate: list:
    pipe list [
      length
      range'
      (filter (i: predicate (elemAt list i)))
    ];

  uncons = list:
    if empty list
      then null
      else pair (head list) (tail list);

  ifilter = predicate:
    pipe' [
      indexed
      (compose [ filter uncurry ] predicate)
      (map snd)
    ];

  imap = imap0;

  indexed = list:
    let
      elemAt' = elemAt list;
    in
    map (index: pair index (elemAt' index)) (range' (length list));

  mapListToAttrs = f: list:
    listToAttrs (map f list);

  maximum = foldStartingWithHead "maximum" max;
  minimum = foldStartingWithHead "minimum" min;

  inherit (bootstrap)
    mergeListOfAttrs
  ;

  partition = predicate: list:
    let
      partitioned = partition predicate list;
    in
    pair partitioned.right partitioned.wrong;

  product = foldl' mul 1;

  range' = n:
    let
      assertion' = assertion.appendScope "range'";
    in
    assert assertion' (!negative n) "negative list size: `${toString n}`";
    genList id n;

  removeNulls = filter notNull;

  replicate = n: val:
    genList (const val) n;

  splitAt = index:
    let
      index' = if negative index then 0 else index;
    in
    list:
      pair
        (sublist 0 index' list)
        (sublist index' (length list - index') list);

  sum = foldl' add 0;
}
