{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    concatListOfLists
    headAndTails
    mapListToAttrs
    mergeListOfAttrs
    removeNulls
  ;
in

{
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

  "removeNulls" = {
    expr = removeNulls [ false null 2 ];
    expected = [ false 2 ];
  };
}
