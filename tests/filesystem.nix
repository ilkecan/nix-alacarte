{ nix-utils }:

let
  inherit (nix-utils)
    filesOf
    relTo
  ;
in

{
  "filesOf_with_suffix" = {
    expr = filesOf ./data {
      withSuffix = ".c";
    };
    expected = [
      ./data/app.c
      ./data/main.c
    ];
  };

  "filesOf_use_relative_paths" = {
    expr = filesOf ./data {
      withSuffix = ".c";
      useRelativePaths = true;
    };
    expected = [
      "app.c"
      "main.c"
    ];
  };

  "filesOf_as_attrs" = {
    expr = filesOf ./data {
      withSuffix = ".c";
      asAttrs = true;
    };
    expected = {
      "app" = ./data/app.c;
      "main" = ./data/main.c;
    };
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
