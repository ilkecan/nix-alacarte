{ nix-utils }:

let
  inherit (nix-utils)
    getFilesWithSuffix
    listFilenamesWithSuffix
    listFilepathsWithSuffix
    relTo
  ;
in

{
  "getFilesWithSuffix" = {
    expr = getFilesWithSuffix ".c" ./data;
    expected = {
      "app" = ./data/app.c;
      "main" = ./data/main.c;
    };
  };

  "listFilenamesWithSuffix" = {
    expr = listFilenamesWithSuffix ".c" ./data;
    expected = [
      "app.c"
      "main.c"
    ];
  };

  "listFilepathsWithSuffix" = {
    expr = listFilepathsWithSuffix ".c" ./data;
    expected = [
      ./data/app.c
      ./data/main.c
    ];
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
