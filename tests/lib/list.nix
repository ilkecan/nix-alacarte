{
  dnm,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    isInt
  ;

  inherit (nix-alacarte)
    add
    compose
    greaterThan'
    indexed
    lessThan
    list
    mod'
    pair
    positive
    range
    range1
    range3
    replicate
  ;

  inherit (list)
    allEqual
    append
    at
    concat
    concatMap
    cons
    count
    difference
    difference'
    drop
    elem
    elemIndex
    elemIndices
    empty
    filter
    filterMap
    find
    findIndex
    findIndices
    flatten
    foldl
    foldl'
    foldr
    forEach
    gen
    groupBy
    head
    ifilter
    imap
    init
    intercalate
    intersect
    intersperse
    is
    last
    length
    map
    mapToAttrs
    maximum
    minimum
    notElem
    notEmpty
    optional
    partition
    prepend
    product
    remove
    reverse
    singleton
    slice
    snoc
    sort
    splitAt
    sum
    tail
    take
    to
    toAttrs
    uncons
    union
    unique
    unzip
    zip
    zipWith
  ;

  inherit (dnm)
    assertEqual
    assertFailure
    assertFalse
    assertNull
    assertTrue
  ;

  firstTenPositiveNumbers = range 1 11;
  listOfFloats = [ 4.1 2.0 1.7 ];
in

{
  allEqual = {
    zero_elem = assertTrue allEqual [ ];
    one_elem = assertTrue allEqual [ 2 ];
    many_elems_true = assertTrue allEqual [ 2 2 2 ];
    many_elems_false = assertFalse allEqual [ 2 3 2 ];
  };

  append = assertEqual {
    actual = append [ 2 ] [ 1 ];
    expected = [ 1 2 ];
  };

  at =
    let
      list = range1 5;
    in
    {
      negative_index = assertFailure at (-4) list;
      index_in_range = assertEqual {
        actual = at 2 list;
        expected = 2;
      };
      index_to_large = assertFailure at 22 list;
    };

  concat = assertEqual {
    actual = concat [ [ 1 2 3 ] [ 4 5 ] [ 6 ] [ ] ];
    expected = [ 1 2 3 4 5 6 ];
  };

  concatMap = assertEqual {
    actual = concatMap (n: range n (n + 3)) [ 3 5 0 ];
    expected = [ 3 4 5 5 6 7 0 1 2 ];
  };

  cons = assertEqual {
    actual = cons 45 [ 2 4 ];
    expected = [ 45 2 4 ];
  };

  count = assertEqual {
    actual = count positive [ 2 (-14) 8 0 (-0.4) 4.8 ];
    expected = 3;
  };

  difference = {
    disjoint = assertEqual {
      actual = difference [ 0 1 2 3 4 ] [ 5 6 7 8 9 ];
      expected = [ 0 1 2 3 4 ];
    };

    not_disjoint = assertEqual {
      actual = difference [ 0 1 2 3 4 ] [ 0 2 4 6 8 ];
      expected = [ 1 3 ];
    };
  };

  difference' = {
    disjoint = assertEqual {
      actual = difference' [ 0 1 2 3 4 ] [ 5 6 7 8 9 ];
      expected = [ 5 6 7 8 9 ];
    };

    not_disjoint = assertEqual {
      actual = difference' [ 0 1 2 3 4 ] [ 0 2 4 6 8 ];
      expected = [ 6 8 ];
    };
  };

  drop =
    let
      list = [ 0 1 2 3 4 ];
    in
    {
      negative = assertEqual {
        actual = drop (-2) list;
        expected = list;
      };

      positive = {
        in_range = assertEqual {
          actual = drop 3 list;
          expected = [ 3 4 ];
        };

        out_of_range = assertEqual {
          actual = drop 9 list;
          expected = [ ];
        };
      };
    };

  elem = {
    true = assertTrue elem 24 [ 123.89 null 24 899 true ];
    false = assertFalse elem "second" [ 1 ];
  };

  elemIndex = {
    not_found = assertNull elemIndex 4 [ 4.5 "martin" ];

    single_elem = assertEqual {
      actual = elemIndex 4 [ 4.5 4 "martin" ];
      expected = 1;
    };

    multi_elems = assertEqual {
      actual = elemIndex 4 [ 4.5 4 "martin" 4 ];
      expected = 1;
    };
  };

  elemIndices = {
    not_found = assertEqual {
      actual = elemIndices 4 [ 4.5 "martin" ];
      expected = [ ];
    };

    single_elem = assertEqual {
      actual = elemIndices 4 [ 4.5 4 "martin" ];
      expected = [ 1 ];
    };

    multi_elems = assertEqual {
      actual = elemIndices 4 [ 4.5 4 "martin" 4 ];
      expected = [ 1 3 ];
    };
  };

  empty = {
    empty_list = assertTrue empty [ ];
    non_empty_list = assertFalse empty [ 2 ];
  };

  notElem = {
    true = assertTrue notElem "second" [ 1 ];
    false = assertFalse notElem 24 [ 123.89 null 24 899 true ];
  };

  notEmpty = {
    empty_list = assertFalse notEmpty [ ];
    non_empty_list = assertTrue notEmpty [ 2 ];
  };

  filter = assertEqual {
    actual = filter positive [ 2 (-14) 8 0 (-0.4) 4.8 ];
    expected = [ 2 8 4.8 ];
  };

  filterMap = assertEqual {
    actual = filterMap (x: if isInt x then 2 * x else null) [ 2 "6" null 8 (-5) 4.9 ];
    expected = [ 4 16 (-10) ];
  };

  find = {
    not_found = assertNull find isInt [ 4.5 "martin" ];

    single_elem = assertEqual {
      actual = find isInt [ 4.5 4 "martin" ];
      expected = 4;
    };

    multi_elems = assertEqual {
      actual = find isInt [ 4.5 4 "martin" 8 ];
      expected = 4;
    };
  };

  findIndex = {
    not_found = assertNull findIndex isInt [ 4.5 "martin" ];

    single_elem = assertEqual {
      actual = findIndex isInt [ 4.5 4 "martin" ];
      expected = 1;
    };

    multi_elems = assertEqual {
      actual = findIndex isInt [ 4.5 4 "martin" 8 ];
      expected = 1;
    };
  };

  findIndices = {
    not_found = assertEqual {
      actual = findIndices isInt [ 4.5 "martin" ];
      expected = [ ];
    };

    single_elem = assertEqual {
      actual = findIndices isInt [ 4.5 4 "martin" ];
      expected = [ 1 ];
    };

    multi_elems = assertEqual {
      actual = findIndices isInt [ 4.5 4 "martin" 8 ];
      expected = [ 1 3 ];
    };
  };

  flatten = {
    not_a_list = assertFailure flatten 4;

    flattened_list = assertEqual {
      actual = flatten [ 0 1 2 3 4 ];
      expected = [ 0 1 2 3 4 ];
    };

    nested_list = assertEqual {
      actual = flatten [ 0 [ 1 [ 2 ] 3 ] 4 ];
      expected = [ 0 1 2 3 4 ];
    };
  };

  foldl = assertEqual {
    actual = foldl (x: y: x + y) "|" [ "a" "b" "c" ];
    expected = "|abc";
  };

  foldl' = assertEqual {
    actual = foldl' (x: y: x + y) "|" [ "a" "b" "c" ];
    expected = "|abc";
  };

  foldr = assertEqual {
    actual = foldr (x: y: x + y) "|" [ "a" "b" "c" ];
    expected = "abc|";
  };

  forEach = assertEqual {
    actual = forEach [ 2 4 8 ] (add 3);
    expected = [ 5 7 11 ];
  };

  gen = assertEqual {
    actual = gen (add 7) 4;
    expected = [ 7 8 9 10 ];
  };

  groupBy = assertEqual {
    actual = groupBy (compose [ toString (mod' 2) ]) [ 2 85 30 18 (-9) ];
    expected = { "-1" = [ (-9) ]; "0" = [ 2 30 18 ]; "1" = [ 85 ]; };
  };

  head = {
    empty_list = assertFailure head [ ];

    non_empty_list = assertEqual {
      actual = head [ 0 1 1 2 ];
      expected = 0;
    };
  };

  ifilter = assertEqual {
    actual = ifilter (i: v: i < 3 || v > 10) [ 1 23 9 3 42 ];
    expected = [ 1 23 9 42 ];
  };

  imap = assertEqual {
    actual = imap (i: n: n + i) [ 0 2 4 ];
    expected = [ 0 3 6 ];
  };

  indexed = assertEqual {
    actual = indexed [ 0 1 1 2 3 ];
    expected = [
      (pair 0 0)
      (pair 1 1)
      (pair 2 1)
      (pair 3 2)
      (pair 4 3)
    ];
  };

  init = {
    empty_list = assertFailure init [ ];

    non_empty_list = assertEqual {
      actual = init [ 1 2 3 ];
      expected = [ 1 2 ];
    };
  };

  intercalate = assertEqual {
    actual = intercalate [ 0 1 ] [ [ 1 3 5 ] [ 4 8 ] [ 3 5 7 ] ];
    expected = [ 1 3 5 0 1 4 8 0 1 3 5 7 ];
  };

  intersect = {
    disjoint = assertEqual {
      actual = intersect [ 0 1 2 ] [ 3 4 5];
      expected = [ ];
    };

    not_disjoint = assertEqual {
      actual = intersect [ 0 1 2 3 4 ] [ 0 2 4 ];
      expected = [ 0 2 4 ];
    };
  };

  intersperse = assertEqual {
    actual = intersperse 0 [ 2 4 6 8 ];
    expected = [ 2 0 4 0 6 0 8 ];
  };

  is = {
    list = assertTrue is [ "some" "list" ];
    not_a_list = assertFalse is 6.4;
  };

  last = {
    empty_list = assertFailure last [ ];

    non_empty_list = assertEqual {
      actual = last [ 1 2 3 ];
      expected = 3;
    };
  };

  length = assertEqual {
    actual = length [ 2.4 8 true ];
    expected = 3;
  };

  map = assertEqual {
    actual = map (add 4) [ 0 2 4 ];
    expected = [ 4 6 8 ];
  };

  mapToAttrs = assertEqual {
    actual = mapToAttrs (e: pair e.name e) [
      { name = "a"; value = 1; }
      { name = "b"; value = 2; }
    ];

    expected = {
      "a" = { name = "a"; value = 1; };
      "b" = { name = "b"; value = 2; };
    };
  };

  maximum = {
    empty = assertFailure maximum [ ];

    single_elem = assertEqual {
      actual = maximum [ 4 ];
      expected = 4;
    };

    multi_elems = assertEqual {
      actual = maximum firstTenPositiveNumbers;
      expected = 10;
    };

    floats = assertEqual {
      actual = maximum listOfFloats;
      expected = 4.1;
    };
  };

  minimum = {
    empty = assertFailure minimum [  ];

    single_elem = assertEqual {
      actual = minimum [ 4 ];
      expected = 4;
    };

    multi_elems = assertEqual {
      actual = minimum firstTenPositiveNumbers;
      expected = 1;
    };

    floats = assertEqual {
      actual = minimum listOfFloats;
      expected = 1.7;
    };
  };

  optional = {
    true = assertEqual {
      actual = optional true [ "a" "list" ];
      expected = [ "a" "list" ];
    };

    false = assertEqual {
      actual = optional false [ "again" "a" "list" ];
      expected = [ ];
    };
  };

  partition = {
    first_empty = assertEqual {
      actual = partition (greaterThan' 50) [ 1 23 9 3 42 ];
      expected = pair [ ] [ 1 23 9 3 42 ];
    };

    second_empty = assertEqual {
      actual = partition (greaterThan' 0) [ 1 23 9 3 42 ];
      expected = pair [ 1 23 9 3 42 ] [ ];
    };

    both_non_empty = assertEqual {
      actual = partition (greaterThan' 10) [ 1 23 9 3 42 ];
      expected = pair [ 23 42 ] [ 1 9 3 ];
    };
  };

  prepend = assertEqual {
    actual = prepend [ 2 ] [ 1 ];
    expected = [ 2 1 ];
  };

  product = {
    empty = assertEqual {
      actual = product [ ];
      expected = 1;
    };

    single_elem = assertEqual {
      actual = product [ 42 ];
      expected = 42;
    };

    multi_elems = assertEqual {
      actual = product firstTenPositiveNumbers;
      expected = 3628800;
    };

    floats = assertEqual {
      actual = product listOfFloats;
      expected = 13.939999999999998;
    };
  };

  range = {
    start_is_greater_than_end = assertEqual {
      actual = range 0 (-4);
      expected = [ ];
    };

    start_and_end_are_the_same = assertEqual {
      actual = range 4 4;
      expected = [ ];
    };

    start_is_less_than_end = assertEqual {
      actual = range 5 10;
      expected = [ 5 6 7 8 9 ];
    };
  };

  range1 = {
    negative = assertEqual {
      actual = range1 (-4);
      expected = [ ];
    };

    zero = assertEqual {
      actual = range1 0;
      expected = [ ];
    };

    positive = assertEqual {
      actual = range1 5;
      expected = [ 0 1 2 3 4 ];
    };
  };

  remove = {
    non_existing_attribute = assertEqual {
      actual = remove true [ false null 2 ];
      expected = [ false null 2 ];
    };

    existing_attribute = assertEqual {
      actual = remove null [ false null 2 ];
      expected = [ false 2 ];
    };
  };

  range3 = {
    positive_step = assertEqual {
      actual = range3 4 13 28;
      expected = [ 13 17 21 25 ];
    };

    negative_step = assertEqual {
      actual = range3 (-3) 13 (-2);
      expected = [ 13 10 7 4 1 ];
    };
  };

  replicate = assertEqual {
    actual = replicate 3 true;
    expected = [ true true true ];
  };

  reverse = {
    empty = assertEqual {
      actual = reverse [ ];
      expected = [ ];
    };

    non_empty = assertEqual {
      actual = reverse [ 0 1 2 3 4 ];
      expected = [ 4 3 2 1 0 ];
    };
  };

  singleton = assertEqual {
    actual = singleton 28;
    expected = [ 28 ];
  };

  slice =
    let
      list = [ 0 1 2 3 4 ];
    in
    {
      start_is_greater_than_end = assertEqual {
        actual = slice 3 2 list;
        expected = [ ];
      };

      start_and_end_are_the_same = assertEqual {
        actual = slice 1 1 list;
        expected = [ ];
      };

      start_is_negative = assertEqual {
        actual = slice (-3) 4 list;
        expected = [ 2 3 ];
      };

      start_is_negative_out_of_bounds = assertEqual {
        actual = slice (-29) 4 list;
        expected = [ 0 1 2 3 ];
      };

      end_is_negative = assertEqual {
        actual = slice 1 (-1) list;
        expected = [ 1 2 3 ];
      };

      end_is_out_of_bounds = assertEqual {
        actual = slice 1 22 list;
        expected = [ 1 2 3 4 ];
      };

      end_is_negative_out_of_bounds = assertEqual {
        actual = slice 3 (-14) list;
        expected = [ ];
      };
    };

  snoc = assertEqual {
    actual = snoc 45 [ 2 4 ];
    expected = [ 2 4 45 ];
  };

  sort = assertEqual {
    actual = sort lessThan [1 6 4 3 2 5 ];
    expected = [ 1 2 3 4 5 6 ];
  };

  splitAt =
    let
      list = [ 0 1 2 3 4 ];
    in
    {
    negative_index = {
      out_of_bounds = assertEqual {
        actual = splitAt (-9) list;
        expected = pair [ ] list;
      };

      in_range = assertEqual {
        actual = splitAt (-2) list;
        expected = pair [ 0 1 2 ] [ 3 4 ];
      };
    };

    positive_index = {
      out_of_bounds = assertEqual {
        actual = splitAt 24 list;
        expected = pair list [ ];
      };

      in_range = assertEqual {
        actual = splitAt 2 list;
        expected = pair [ 0 1 ] [ 2 3 4 ];
      };
    };
  };

  sum = {
    empty = assertEqual {
      actual = sum [ ];
      expected = 0;
    };

    single_elem = assertEqual {
      actual = sum [ 42 ];
      expected = 42;
    };

    multi_elems = assertEqual {
      actual = sum firstTenPositiveNumbers;
      expected = 55;
    };

    floats = assertEqual {
      actual = sum listOfFloats;
      expected = 7.8;
    };
  };

  tail = {
    empty_list = assertFailure tail [ ];

    non_empty_list = assertEqual {
      actual = tail [ 0 1 1 2 ];
      expected = [ 1 1 2 ];
    };
  };

  take =
    let
      list = [ 0 1 2 3 4 ];
    in
    {
      negative = assertEqual {
        actual = take (-2) list;
        expected = [ ];
      };

      positive = {
        in_range = assertEqual {
          actual = take 3 list;
          expected = [ 0 1 2 ];
        };

        out_of_range = assertEqual {
          actual = take 9 list;
          expected = list;
        };
      };
    };

  to = {
    element = assertEqual {
      actual = to 24;
      expected = [ 24 ];
    };

    list = assertEqual {
      actual = to [ 1.20 ];
      expected = [ 1.20 ];
    };
  };

  toAttrs = assertEqual {
    actual = toAttrs [ (pair "a" 13) (pair "b" 21) ];
    expected = { a = 13; b = 21; };
  };

  uncons = {
    empty = assertNull uncons [ ];

    single_elem = assertEqual {
      actual = uncons [ true ];
      expected = pair true [ ];
    };

    multi_elems = assertEqual {
      actual = uncons [ 2 3 5 ];
      expected = pair 2 [ 3 5 ];
    };
  };

  union = {
    repeating_elems_are_not_added = assertEqual {
      actual = union [ 0 1 2 ] [ 3 1 4 ];
      expected = [ 0 1 2 3 4 ];
    };

    duplicates_from_right_are_not_added = assertEqual {
      actual = union [ 0 1 2 ] [ 3 4 3 ];
      expected = [ 0 1 2 3 4 ];
    };

    duplicates_from_left_are_removed = assertEqual {
      actual = union [ 2 0 1 2 ] [ 3 4 ];
      expected = [ 2 0 1 3 4 ];
    };
  };

  unique = assertEqual {
    actual = unique [ 1 2 3 4 3 2 1 2 4 3 5 ];
    expected = [ 1 2 3 4 5 ];
  };

  unzip = {
    empty = assertEqual {
      actual = unzip [ ];
      expected = pair [ ] [ ];
    };

    non_empty = assertEqual {
      actual = unzip [ (pair 1 "a") (pair 2 "b") (pair 3 "c") ];
      expected = pair [ 1 2 3 ] [ "a" "b" "c" ];
    };
  };

  zip = {
    zip_with_empty_list = assertEqual {
      actual = zip [ ] [ 2 4 6 ];
      expected = [ ];
    };

    lists_with_same_length = assertEqual {
      actual = zip [ 1 2 3 ] [ "a" "b" "c" ];
      expected = [ (pair 1 "a") (pair 2 "b") (pair 3 "c") ];
    };
  };

  zipWith = assertEqual {
    actual = zipWith add [ 1 2 3 ] [ 4 5 6 ];
    expected = [ 5 7 9 ];
  };
}
