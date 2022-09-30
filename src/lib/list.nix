{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    add
    elemAt
    foldl'
    mul
  ;

  inherit (lib)
    const
    pipe
    flip
    id
    max
    min
    sublist
  ;

  inherit (nix-alacarte)
    compose
    equalTo
    indexed
    list
    negative
    notEqualTo
    notNull
    pair
    pipe'
    range'
    snd
  ;

  inherit (list)
    all
    append
    at
    empty
    filter
    findIndex
    findIndices
    gen
    head
    length
    prepend
    singleton
    tail
    toAttrs
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
  indexed = list:
    let
      elemAt' = elemAt list;
    in
    map (index: pair index (elemAt' index)) (range' (length list));

  list = {
    all = builtins.all;

    allEqual = list:
      all (equalTo (head list)) list;

    any = builtins.any;

    append = right: left:
      left ++ right;

    at = flip elemAt;

    concat = builtins.concatLists;

    cons = compose [ prepend singleton ];

    elem = builtins.elem;

    elemIndex = compose [ findIndex equalTo ];

    elemIndices = compose [ findIndices equalTo ];

    empty = equalTo [ ];

    filter = builtins.filter;

    find = pred:
      lib.findFirst pred null;

    findIndex = predicate: list:
      let
        indices = findIndices predicate list;
      in
      if empty indices then null else head indices; 

    findIndices = predicate: list:
      let
        elemAt' = elemAt list;
      in
      pipe list [
        length
        range'
        (filter (compose [ predicate elemAt' ]))
      ];

    gen = builtins.genList;

    head = builtins.head;

    ifilter = predicate:
      let
        predicate' = pair.uncurry predicate;
      in
      pipe' [
        indexed
        (filter predicate')
        (map snd)
      ];

    imap = lib.imap0;

    init = lib.init;

    last = lib.last;

    length = builtins.length;

    map = builtins.map;

    maximum = foldStartingWithHead "maximum" max;

    mapToAttrs = f:
      compose [ toAttrs (map f) ];

    minimum = foldStartingWithHead "minimum" min;

    notEmpty = notEqualTo [ ];

    nub = lib.unique;

    optional = lib.optionals;

    partition = predicate: list:
      let
        partitioned = builtins.partition predicate list;
      in
      pair partitioned.right partitioned.wrong;

    prepend = left: right:
      left ++ right;

    product = foldl' mul 1;

    removeNulls = filter notNull;

    singleton = lib.singleton;

    snoc = compose [ append singleton ];

    splitAt = index:
      let
        index' = if negative index then 0 else index;
      in
      list:
        pair
          (sublist 0 index' list)
          (sublist index' (length list - index') list);

    sum = foldl' add 0;

    tail = builtins.tail;

    toAttrs = builtins.listToAttrs;

    uncons = list:
      if empty list
        then null
        else pair (head list) (tail list);
  };

  range' = n:
    let
      assertion' = assertion.appendScope "range'";
    in
    assert assertion' (!negative n) "negative list size: `${toString n}`";
    gen id n;

  replicate = n: val:
    gen (const val) n;
}
