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

  inherit (lib)
    nameValuePair
    range
  ;

  inherit (nix-alacarte)
    allEqual
    append
    prepend
    appendElem
    prependElem
    empty
    notEmpty
    findIndex
    findIndices
    headAndTails
    mapListToAttrs
    mergeListOfAttrs
    maximum
    minimum
    product
    removeNulls
    replicate
    splitAt
    sum
  ;

  inherit (dnm)
    assertEqual
    assertFailure
    assertFalse
    assertNull
    assertTrue
  ;

  firstTenPositiveNumbers = range 1 10;
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

  prepend = assertEqual {
    actual = prepend [ 2 ] [ 1 ];
    expected = [ 2 1 ];
  };

  appendElem = assertEqual {
    actual = appendElem 45 [ 2 4 ];
    expected = [ 2 4 45 ];
  };

  prependElem = assertEqual {
    actual = prependElem 45 [ 2 4 ];
    expected = [ 45 2 4 ];
  };

  empty = {
    empty_list = assertTrue empty [ ];
    non_empty_list = assertFalse empty [ 2 ];
  };

  notEmpty = {
    empty_list = assertFalse notEmpty [ ];
    non_empty_list = assertTrue notEmpty [ 2 ];
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

  headAndTails = {
    empty = assertFailure headAndTails [ ];

    tail_not_empty = assertEqual {
      actual = headAndTails [ 2 3 5 ];
      expected = { head = 2; tail = [ 3 5 ]; };
    };

    tail_empty = assertEqual {
      actual = headAndTails [ true ];
      expected = { head = true; tail = [ ]; };
    };
  };


  mapListToAttrs = assertEqual {
    actual = mapListToAttrs (e: nameValuePair e.name e) [
      { name = "a"; value = 1; }
      { name = "b"; value = 2; }
    ];

    expected = {
      "a" = { name = "a"; value = 1; };
      "b" = { name = "b"; value = 2; };
    };
  };

  mergeListOfAttrs = {
    merge_leafs = assertEqual {
      actual = mergeListOfAttrs [
        { "a" = 1; }
        { "b" = 2; }
      ];

      expected = {
        "a" = 1;
        "b" = 2;
      };
    };

    recursive_merge = assertEqual {
      actual = mergeListOfAttrs [ { a = { b = 3; }; } { a = { c = 4; }; } ];
      expected = { a = { b = 3; c = 4; }; };
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

  removeNulls = assertEqual {
    actual = removeNulls [ false null 2 ];
    expected = [ false 2 ];
  };

  replicate = assertEqual {
    actual = replicate 3 true;
    expected = [ true true true ];
  };

  splitAt = {
    left_and_right_non_empty = assertEqual {
      actual = splitAt 4 [ "equal" "to" "the" "value" "returned" ];
      expected = {
        left = [ "equal" "to" "the" "value" ];
        right = [ "returned" ];
      };
    };

    right_empty = assertEqual {
      actual = splitAt 4 [ "equal" "to" "the"  ];
      expected = {
        left = [ "equal" "to" "the" ];
        right = [ ];
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
}
