{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte.path)
    components
    isAbsolute
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  components = {
    relative_path = assertEqual {
      actual = components "a/b";
      expected = [ "a" "b" ];
    };

    repeated_separator = assertEqual {
      actual = components "a//b";
      expected = [ "a" "b" ];
    };

    dot_in_the_middle = assertEqual {
      actual = components "a/./b";
      expected = [ "a" "b" ];
    };

    separator_at_the_end = assertEqual {
      actual = components "a/b/";
      expected = [ "a" "b" ];
    };

    dot_at_the_end = assertEqual {
      actual = components "a/b/.";
      expected = [ "a" "b" ];
    };

    dot_at_the_beginning = assertEqual {
      actual = components "./a/b";
      expected = [ "." "a" "b" ];
    };

    separator_at_the_beginning = assertEqual {
      actual = components "/a/b";
      expected = [ "/" "a" "b" ];
    };

    double_dot_is_kept = assertEqual {
      actual = components "a/b/../c";
      expected = [ "a" "b" ".." "c" ];
    };
  };

  isAbsolute = {
    path = assertTrue isAbsolute ./fixtures/example-project;
    string_absolute = assertTrue isAbsolute "/var/root";
    string_relative = assertFalse isAbsolute ".git/config";
  };
}
