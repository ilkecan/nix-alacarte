{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    allEqual
    concatListOfLists
    headAndTails
    mapListToAttrs
    mergeListOfAttrs
    removeNulls
    replicate
  ;
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

  "concatListOfLists" = {
    expr = concatListOfLists [
      [ 1 2 ]
      []
      [ 3 ]
      [ 4 5 6 ]
    ];

    expected = [ 1 2 3 4 5 6 ];
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

  "removeNulls" = {
    expr = removeNulls [ false null 2 ];
    expected = [ false 2 ];
  };

  "replicate" = {
    expr = replicate 3 true;
    expected = [ true true true ];
  };
}
