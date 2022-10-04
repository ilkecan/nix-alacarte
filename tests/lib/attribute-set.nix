{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    attrs
    lessThan
    list
    pair
  ;

  inherit (attrs)
    cartesianProduct
    cat
    concat
    count
    filter
    foldl
    foldl'
    foldr
    forEach
    gen
    get
    getByPath
    getMany
    has
    hasByPath
    intersect
    is
    map
    map'
    mapToList
    mapValues
    merge
    merge'
    names
    optional
    partition
    remove
    removeNulls
    rename
    set
    setByPath
    toList
    values
    zipWith
  ;

  inherit (dnm)
    assertEqual
    assertFailure
    assertFalse
    assertNull
    assertTrue
  ;
in

{
  cartesianProduct = assertEqual {
    actual = cartesianProduct { x = [ 3 5 ]; y = [ "m" "l" ]; };
    expected = [
      { x = 3; y = "m"; }
      { x = 3; y = "l"; }
      { x = 5; y = "m"; }
      { x = 5; y = "l"; }
    ];
  };

  cat = assertEqual {
    actual = cat "x" [ { x = 2.4; } { x = null; y = true; } { y = "2"; } ];
    expected = [ 2.4 null ];
  };

  concat = {
    merge_leafs = assertEqual {
      actual = concat [ { "a" = 1; } { "b" = 2; } ];
      expected = { "a" = 1; "b" = 2; };
    };

    recursive_merge = assertEqual {
      actual = concat [ { a = { b = 3; }; } { a = { c = 4; }; } ];
      expected = { a = { b = 3; c = 4; }; };
    };
  };

  count = assertEqual {
    actual = count lessThan { a = "c"; b = "a"; c = "c"; z = "d"; w = "y"; };
    expected = 2;
  };

  filter = assertEqual {
    actual = filter lessThan { a = "c"; b = "a"; c = "c"; z = "d"; w = "y"; };
    expected = { a = "c"; w = "y"; };
  };

  foldl = assertEqual {
    actual = foldl (x: y: x + y) "|" [ { x = "a"; } { x = "b"; } { x = "c"; } ];
    expected = { x = "|abc"; };
  };

  foldl' = assertEqual {
    actual = foldl' (x: y: x + y) "|" [ { x = "a"; } { x = "b"; } { x = "c"; } ];
    expected = { x = "|abc"; };
  };

  foldr = assertEqual {
    actual = foldr (x: y: x + y) "|" [ { x = "a"; } { x = "b"; } { x = "c"; } ];
    expected = { x = "abc|"; };
  };

  forEach = assertEqual {
    actual = forEach { x = "foo"; y = "bar"; } (name: value:
      name + "-" + value
    );
    expected = { x = "x-foo"; y = "y-bar"; };
  };

  gen = assertEqual {
    actual = gen [ "x" "y" "z" ] (n: "|${n}|");
    expected = { x = "|x|"; y = "|y|"; z = "|z|"; };
  };

  get = {
    attr_exists = assertEqual {
      actual = get "b" { a = 4; b = 9; };
      expected = 9;
    };

    attr_does_not_exist = assertFailure get "c" { a = 4; b = 9; };
  };

  getByPath =
    let
      attrs = { x = { y = { z = 123; y = 2.0; }; z = "abc"; }; z = true; };
    in
    {
      empty_attr_path = assertEqual {
        actual = getByPath [ ] attrs;
        expected = attrs;
      };

      attr_exists = assertEqual {
        actual = getByPath [ "x" "y" "z" ] attrs;
        expected = 123;
      };

      attr_does_not_exist = assertNull getByPath [ "a" "b" "c" ] attrs;
    };

  getMany = {
    empty = assertEqual {
      actual = getMany [ ] { x = "foo"; y = "bar"; };
      expected = { };
    };

    get_only_existing_attributes = assertEqual {
      actual = getMany [ "y" "z" ] { x = "foo"; y = "bar"; };
      expected = { y = "bar"; };
    };
  };

  has = {
    attr_exists = assertTrue has "x" { "x" = 23; };
    attr_does_not_exist = assertFalse has "y" { "x" = 23; };
  };

  hasByPath =
    let
      attrs = { x = { y = { z = 123; y = 2.0; }; z = "abc"; }; z = true; };
    in
    {
      empty_attr_path = assertTrue hasByPath [ ] attrs;
      attr_exists = assertTrue hasByPath [ "x" "y" ] attrs;
      attr_does_not_exist = assertFalse hasByPath [ "x" "x" "y" ] attrs;
    };

  intersect = {
    disjoint = assertEqual {
      actual = intersect { x = 2; } { y = 4; };
      expected = { };
    };

    values_are_from_the_second_set = assertEqual {
      actual = intersect { x = 2; y = 2.4; } { y = 4; z = false; };
      expected = { y = 4; };
    };
  };

  is = {
    attrs = assertTrue is { some = "attrs"; };
    not_an_attrs = assertFalse is 24.4;
  };

  map = assertEqual {
    actual = map (n: v: "${n}:${toString v}") { a = 1; b = 2; c = 3; };
    expected = { a = "a:1"; b = "b:2"; c = "c:3"; };
  };

  map' = assertEqual {
    actual = map' (n: v: pair (toString v) n) { a = 1; b = 2; c = 3; };
    expected = { "1" = "a"; "2" = "b"; "3" = "c"; };
  };

  mapToList = assertEqual {
    actual = mapToList (name: value: name + value) { a = "1"; b = "2"; };
    expected = [ "a1" "b2" ];
  };

  mapValues = assertEqual {
    actual = mapValues toString { a = 1; b = 2; c = 3; };
    expected = { a = "1"; b = "2"; c = "3"; };
  };

  merge = {
    new_attributes_are_added = assertEqual {
      actual = merge { x = 1; } { y = 4; };
      expected = { x = 1; y = 4; };
    };

    old_attributes_are_overwritten = assertEqual {
      actual = merge { x = 1; y = 4; } { y = 8; };
      expected = { x = 1; y = 8; };
    };
  };

  merge' = {
    new_attributes_are_added = assertEqual {
      actual = merge' { x = 1; } { y = 4; };
      expected = { x = 1; y = 4; };
    };

    old_attributes_are_kept = assertEqual {
      actual = merge' { x = 1; y = 4; } { y = 8; };
      expected = { x = 1; y = 4; };
    };
  };

  names = assertEqual {
    actual = names { c = null; x = 123; y = 41.2; };
    expected = [ "c" "x" "y" ];
  };

  optional = {
    true = assertEqual {
      actual = optional true { x = "an"; y = "attrs"; };
      expected = { x = "an"; y = "attrs"; };
    };

    false = assertEqual {
      actual = optional false { x = "again"; y = "an"; z = "attrs"; };
      expected = { };
    };
  };

  partition = {
    first_empty = assertEqual {
      actual = partition (name: value: name != "foo" && value < 10) { foo = 12; bar = 20; };
      expected = pair { } { foo = 12; bar = 20; };
    };

    second_empty = assertEqual {
      actual = partition (name: value: name != "bar" || value > 15) { foo = 12; bar = 20; };
      expected = pair { foo = 12; bar = 20; } { };
    };

    both_non_empty = assertEqual {
      actual = partition (name: value: name != "foo" && value > 10) { foo = 12; bar = 20; };
      expected = pair { bar = 20; } { foo = 12; };
    };
  };

  remove =
    let
      attrs' = { x = "12"; y = 83; z = true; };
    in
    {
      empty_list = assertEqual {
        actual = remove [ ] attrs';
        expected = attrs';
      };

      attributes_that_does_not_exist = assertEqual {
        actual = remove [ "a" "b" "c" ] attrs';
        expected = attrs';
      };

      attributes_that_exists = assertEqual {
        actual = remove [ "x" "z" ] attrs';
        expected = { y = 83; };
      };
    };

  removeNulls = assertEqual {
    actual = removeNulls { a = false; b = null; c = 2; };
    expected = { a = false; c = 2; };
  };

  rename = assertEqual {
    actual = rename (name: value: "${name}-${toString value}") { a = 1; b = 2; };
    expected = { "a-1" = 1; "b-2" = 2; };
  };

  set = {
    existing = assertEqual {
      actual = set "existing" true { existing = false; };
      expected = { existing = true; };
    };

    new = assertEqual {
      actual = set "new" true { existing = false; };
      expected = { existing = false; new = true; };
    };
  };

  setByPath = {
    depth_0 = assertEqual {
      actual = setByPath [ ] true { top = false; other = "hey"; };
      expected = true;
    };

    depth_1 = assertEqual {
      actual = setByPath [ "top" ] true { top = false; other = "hey"; };
      expected = { top = true; other = "hey"; };
    };

    depth_3 = assertEqual {
      actual = setByPath [ "top" "middle" "bottom" ] 42 { top = { middle = { bottom = null; }; other = "hey"; }; };
      expected = { top = { middle = { bottom = 42; }; other = "hey"; }; };
    };
  };

  toList = assertEqual {
    actual = toList { a = 1; b = 2; c = 3; };
    expected = [ (pair "a" 1) (pair "b" 2) (pair "c" 3) ];
  };

  values = assertEqual {
    actual = values { c = null; x = 123; y = 41.2; };
    expected = [ null 123 41.2 ];
  };

  zipWith = assertEqual {
    actual = zipWith (_: list.sum) [ { a = 13; y = -2; } { a = 4; c = -19; } ];
    expected = { a = 17; c = -19; y = -2; };
  };
}
