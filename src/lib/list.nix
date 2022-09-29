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
    notEqualTo
    negative
    notNull
    prepend
    range'
  ;

  inherit (nix-alacarte.internal)
    assert'
    throw'
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

  headAndTail =
    let
      assert'' = assert'.appendScope "headAndTail";
    in
    list:
      assert assert'' (list != [ ]) "empty list";
      {
        "0" = head list;
        "1" = tail list;
      };

  imap = imap0;

  indexed = list:
    let
      elemAt' = elemAt list;
      index = n:
        { index = n; element = elemAt' n; };
    in
    map index (range' (length list));

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
    {
      "0" = partitioned.right;
      "1" = partitioned.wrong;
    };

  product = foldl' mul 1;

  range' = n:
    let
      assert'' = assert'.appendScope "range'";
    in
    assert assert'' (!negative n) "negative list size: `${toString n}`";
    genList id n;

  removeNulls = filter notNull;

  replicate = n: val:
    genList (const val) n;

  splitAt = index: list: {
    left = sublist 0 index list;
    right = sublist index (length list - index) list;
  };

  sum = foldl' add 0;

  unindexed =
    let
      assert'' = assert'.appendScope "unindexed";
      throw'' = throw'.appendScope "unindexed";
    in
    map (e:
      assert assert'' (isAttrs e) "list element must be an attr set";
      throw''.unlessGetAttr "element" e
    );
}
