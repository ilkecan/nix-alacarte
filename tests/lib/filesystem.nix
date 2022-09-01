{
  dnm,
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    filesOf
    relTo
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  filesOf = {
    with_extension = assertEqual {
      actual = filesOf ./data {
        withExtension = "c";
      };
      expected = [
        ./data/app.c
        ./data/main.c
      ];
    };

    return_filename = assertEqual {
      actual = filesOf ./data {
        withExtension = "c";
        return = "name";
      };
      expected = [
        "app.c"
        "main.c"
      ];
    };

    as_attrs = assertEqual {
      actual = filesOf ./data {
        withExtension = "c";
        asAttrs = true;
      };
      expected = {
        "app" = ./data/app.c;
        "main" = ./data/main.c;
      };
    };

    recursive_and_as_attrs = assertEqual {
      actual = filesOf ./data {
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

    excluded_paths = assertEqual {
      actual = filesOf ./data {
        asAttrs = true;
        excludedPaths = [ ./data/app.c ];
        withExtension = "c";
      };
      expected = {
        "main" = ./data/main.c;
      };
    };

    strip_suffix = assertEqual {
      actual = filesOf ./data {
        withExtension = "c";
        return = "stem";
      };
      expected = [
        "app"
        "main"
      ];
    };
  };

  relTo = {
    path_path = assertEqual {
      actual = relTo ./data /abc;
      expected = ./data/abc;
    };

    path_string = assertEqual {
      actual = relTo ./data "abc";
      expected = ./data/abc;
    };

    string_path = assertEqual {
      actual = relTo "./data" /abc;
      expected = "./data//abc";
    };

    string_string = assertEqual {
      actual = relTo "./data" "abc";
      expected = "./data/abc";
    };
  };
}
