{ nix-utils }:

let
  inherit (nix-utils)
    getFilesWithSuffix
  ;
in

{
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
}
