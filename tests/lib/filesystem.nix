{ nix-utils }:

let
  inherit (nix-utils.lib)
    filesOf
    relTo
  ;
in

{
  "filesOf_with_suffix" = {
    expr = filesOf ./data {
      withExtension = "c";
    };
    expected = [
      ./data/app.c
      ./data/main.c
    ];
  };

  "filesOf_use_relative_paths" = {
    expr = filesOf ./data {
      withExtension = "c";
      return = "name";
    };
    expected = [
      "app.c"
      "main.c"
    ];
  };

  "filesOf_as_attrs" = {
    expr = filesOf ./data {
      withExtension = "c";
      asAttrs = true;
    };
    expected = {
      "app" = ./data/app.c;
      "main" = ./data/main.c;
    };
  };

  "filesOf_recursive as_attrs" = {
    expr = filesOf ./data {
      asAttrs = true;
      recursive = true;
      withExtension = "c";
    };
    expected = {
      app = ./data/app.c;
      main = ./data/main.c;
      subdir = {
        log = ./data/subdir/log.c;
      };
    };
  };

  "filesOf_excluded_paths" = {
    expr = filesOf ./data {
      asAttrs = true;
      excludedPaths = [ ./data/app.c ];
      withExtension = "c";
    };
    expected = {
      "main" = ./data/main.c;
    };
  };

  "filesOf_strip_suffix" = {
    expr = filesOf ./data {
      withExtension = "c";
      return = "stem";
    };
    expected = [
      "app"
      "main"
    ];
  };

  "relTo_path_path" = {
    expr = relTo ./data /abc;
    expected = ./data/abc;
  };

  "relTo_path_string" = {
    expr = relTo ./data "abc";
    expected = ./data/abc;
  };

  "relTo_string_path" = {
    expr = relTo "./data" /abc;
    expected = "./data//abc";
  };
  "relTo_string_string" = {
    expr = relTo "./data" "abc";
    expected = "./data/abc";
  };
}
