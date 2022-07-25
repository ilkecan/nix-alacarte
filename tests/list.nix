{ nix-utils }:

let
  inherit (nix-utils)
    mapListToAttrs
    mergeListOfAttrs
  ;
in

{
  "mapListToAttrs" = {
    expr = mapListToAttrs (e: { ${e.name} = e; }) [
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
}
