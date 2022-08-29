{
  lib,
  nix-utils,
  ...
}:

let
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
    product
    removeNulls
    replicate
    splitAt
    sum
  ;

  firstTenPositiveNumbers = range 1 10;
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
    expr = product [ 4.1 2.0 1.7 ];
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
    expr = sum [ 4.1 2.0 1.7 ];
    expected = 7.8;
  };
}
