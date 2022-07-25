{ nix-utils }:

let
  inherit (nix-utils)
    getFilesWithSuffix
    getFilesWithSuffix'
    relTo
  ;
in

{
  "getFilesWithSuffix'" = {
    expr = getFilesWithSuffix' ".c" ./data;
    expected = {
      "app.c" = ./data/app.c;
      "main.c" = ./data/main.c;
    };
  };

  "getFilesWithSuffix" = {
    expr = getFilesWithSuffix ".c" ./data;
    expected = [
      ./data/app.c
      ./data/main.c
    ];
  };

  "getFilesWithSuffix_empty" = {
    expr = getFilesWithSuffix ".h" ./data;
    expected = [ ];
  };

  "relTo_path" = {
    expr = relTo ./data "abc";
    expected = ./data/abc;
  };

  "relTo_string" = {
    expr = relTo (toString ./data) "abc";
    expected = toString ./data/abc;
  };
}
