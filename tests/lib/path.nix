{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte.path)
    components
    exists
    isAbsolute
    relativeTo
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  components = {
    empty = assertEqual {
      actual = components "";
      expected = [ ];
    };

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

  exists = {
    existing_path = assertTrue exists ./fixtures/example-project;
    non_existing_path = assertFalse exists ./fixtures81;
  };

  isAbsolute = {
    path = assertTrue isAbsolute ./fixtures/example-project;
    string_empty = assertFalse isAbsolute "";
    string_absolute = assertTrue isAbsolute "/var/root";
    string_relative = assertFalse isAbsolute ".git/config";
  };

  relativeTo = {
    path_path = assertEqual {
      actual = relativeTo ./example /abc;
      expected = ./example/abc;
    };

    path_string = assertEqual {
      actual = relativeTo ./example "abc";
      expected = ./example/abc;
    };

    string_path = assertEqual {
      actual = relativeTo "./example" /abc;
      expected = "./example//abc";
    };

    string_string = assertEqual {
      actual = relativeTo "./example" "abc";
      expected = "./example/abc";
    };
  };
}
