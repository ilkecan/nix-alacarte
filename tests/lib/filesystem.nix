{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    filesOf
    importDirectory
    nixFiles
    relTo
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  filesOf = {
    with_extension = assertEqual {
      actual = filesOf {
        withExtension = "c";
      } ./fixtures/example-project;
      expected = [
        ./fixtures/example-project/app.c
        ./fixtures/example-project/main.c
      ];
    };

    return_filename = assertEqual {
      actual = filesOf {
        withExtension = "c";
        return = "name";
      } ./fixtures/example-project;
      expected = [
        "app.c"
        "main.c"
      ];
    };

    as_attrs = assertEqual {
      actual = filesOf {
        withExtension = "c";
        asAttrs = true;
      } ./fixtures/example-project;
      expected = {
        "app" = ./fixtures/example-project/app.c;
        "main" = ./fixtures/example-project/main.c;
      };
    };

    recursive_and_as_attrs = assertEqual {
      actual = filesOf {
        asAttrs = true;
        recursive = true;
        withExtension = "c";
      } ./fixtures/example-project;
      expected = {
        app = ./fixtures/example-project/app.c;
        main = ./fixtures/example-project/main.c;
        subdir = {
          log = ./fixtures/example-project/subdir/log.c;
        };
      };
    };

    exclude_paths = assertEqual {
      actual = filesOf {
        asAttrs = true;
        excludedPaths = [ ./fixtures/example-project/app.c ];
        withExtension = "c";
      } ./fixtures/example-project;
      expected = {
        "main" = ./fixtures/example-project/main.c;
      };
    };

    exclude_relative_paths = assertEqual {
      actual = filesOf {
        asAttrs = true;
        excludedPaths = [ "app.c" ];
        withExtension = "c";
      } ./fixtures/example-project;
      expected = {
        "main" = ./fixtures/example-project/main.c;
      };
    };

    strip_suffix = assertEqual {
      actual = filesOf {
        withExtension = "c";
        return = "stem";
      } ./fixtures/example-project;
      expected = [
        "app"
        "main"
      ];
    };
  };

  importDirectory = assertEqual {
    actual = importDirectory { } ./fixtures/nix-files { x = 5; y = 10; z = 12; };
    expected = { fooBar = 12; baz = 5; };
  };

  nixFiles = assertEqual {
    actual = nixFiles { } ./fixtures/nix-files;
    expected = { fooBar = ./fixtures/nix-files/foo-bar.nix; baz = ./fixtures/nix-files/baz.nix; };
  };

  relTo = {
    path_path = assertEqual {
      actual = relTo ./example /abc;
      expected = ./example/abc;
    };

    path_string = assertEqual {
      actual = relTo ./example "abc";
      expected = ./example/abc;
    };

    string_path = assertEqual {
      actual = relTo "./example" /abc;
      expected = "./example//abc";
    };

    string_string = assertEqual {
      actual = relTo "./example" "abc";
      expected = "./example/abc";
    };
  };
}
