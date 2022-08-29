{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    tryEval
  ;

  inherit (lib)
    range
  ;

  inherit (nix-utils)
    allEqual
    append
    prepend
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

  firstTenPositiveNumbers = range 1 10;
  listOfFloats = [ 4.1 2.0 1.7 ];
in

{
  "allEqual_zero_elem" = {
    expr = allEqual [ ];
    expected = true;
  };

  "allEqual_one_elem" = {
    expr = allEqual [ 2 ];
    expected = true;
  };

  "allEqual_many_elems_true" = {
    expr = allEqual [ 2 2 2 ];
    expected = true;
  };

  "allEqual_many_elems_false" = {
    expr = allEqual [ 2 3 2 ];
    expected = false;
  };

  "append" = {
    expr = append [ 1 ] [ 2 ];
    expected = [ 1 2 ];
  };

  "prepend" = {
    expr = prepend [ 1 ] [ 2 ];
    expected = [ 2 1 ];
  };

  "headAndTails" = {
    expr = headAndTails [ 2 3 5 ];
    expected = { head = 2; tail = [ 3 5 ]; };
  };

  "headAndTails_tail_empty" = {
    expr = headAndTails [ true ];
    expected = { head = true; tail = [ ]; };
  };

  "mapListToAttrs" = {
    expr = mapListToAttrs (e: { name = e.name; value = e; }) [
      {
        name = "a";
        value = 1;
      }
      {
        name = "b";
        value = 2;
      }
    ];

    expected = {
      "a" = {
        name = "a";
        value = 1;
      };
      "b" = {
        name = "b";
        value = 2;
      };
    };
  };

  "mergeListOfAttrs" = {
    expr = mergeListOfAttrs [
      { "a" = 1; }
      { "b" = 2; }
    ];

    expected = {
      "a" = 1;
      "b" = 2;
    };
  };

  "mergeListOfAttrs_recursive_merge" = {
    expr = mergeListOfAttrs [ { a = { b = 3; };} { a = { c = 4; }; } ];
    expected = { a = { b = 3; c = 4; }; };
  };

  "maximum_empty" = {
    expr = tryEval (maximum [ ]);
    expected = { success = false; value = false; };
  };

  "maximum_single_elem" = {
    expr = maximum [ 4 ];
    expected = 4;
  };

  "maximum_multi_elems" = {
    expr = maximum firstTenPositiveNumbers;
    expected = 10;
  };

  "maximum_floats" = {
    expr = maximum listOfFloats;
    expected = 4.1;
  };

  "minimum_empty" = {
    expr = tryEval (minimum [ ]);
    expected = { success = false; value = false; };
  };

  "minimum_single_elem" = {
    expr = minimum [ 4 ];
    expected = 4;
  };

  "minimum_multi_elems" = {
    expr = minimum firstTenPositiveNumbers;
    expected = 1;
  };

  "minimum_floats" = {
    expr = minimum listOfFloats;
    expected = 1.7;
  };

  "product_empty" = {
    expr = product [ ];
    expected = 1;
  };

  "product_single_elem" = {
    expr = product [ 42 ];
    expected = 42;
  };

  "product_multi_elems" = {
    expr = product firstTenPositiveNumbers;
    expected = 3628800;
  };

  "product_floats" = {
    expr = product listOfFloats;
    expected = 13.939999999999998;
  };

  "removeNulls" = {
    expr = removeNulls [ false null 2 ];
    expected = [ false 2 ];
  };

  "replicate" = {
    expr = replicate 3 true;
    expected = [ true true true ];
  };

  "splitAt" = {
    expr = splitAt 4 [ "equal" "to" "the" "value" "returned" ];
    expected = {
      left = [ "equal" "to" "the" "value" ];
      right = [ "returned" ];
    };
  };

  "splitAt_right_empty" = {
    expr = splitAt 4 [ "equal" "to" "the"  ];
    expected = {
      left = [ "equal" "to" "the" ];
      right = [ ];
    };
  };

  "sum_empty" = {
    expr = sum [ ];
    expected = 0;
  };

  "sum_single_elem" = {
    expr = sum [ 42 ];
    expected = 42;
  };

  "sum_multi_elems" = {
    expr = sum firstTenPositiveNumbers;
    expected = 55;
  };

  "sum_floats" = {
    expr = sum listOfFloats;
    expected = 7.8;
  };
}
