{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    isAbsolutePath
    pathComponents
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  isAbsolutePath = {
    path = assertTrue isAbsolutePath ./fixtures/example-project;
    string_absolute = assertTrue isAbsolutePath "/var/root";
    string_relative = assertFalse isAbsolutePath ".git/config";
  };

  pathComponents = {
    relative_path = assertEqual {
      actual = pathComponents "a/b";
      expected = [ "a" "b" ];
    };

    repeated_separator = assertEqual {
      actual = pathComponents "a//b";
      expected = [ "a" "b" ];
    };

    dot_in_the_middle = assertEqual {
      actual = pathComponents "a/./b";
      expected = [ "a" "b" ];
    };

    separator_at_the_end = assertEqual {
      actual = pathComponents "a/b/";
      expected = [ "a" "b" ];
    };

    dot_at_the_end = assertEqual {
      actual = pathComponents "a/b/.";
      expected = [ "a" "b" ];
    };

    dot_at_the_beginning = assertEqual {
      actual = pathComponents "./a/b";
      expected = [ "." "a" "b" ];
    };

    separator_at_the_beginning = assertEqual {
      actual = pathComponents "/a/b";
      expected = [ "/" "a" "b" ];
    };

    double_dot_is_kept = assertEqual {
      actual = pathComponents "a/b/../c";
      expected = [ "a" "b" ".." "c" ];
    };
  };
}
