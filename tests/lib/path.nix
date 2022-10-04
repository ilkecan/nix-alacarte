{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    path
  ;

  inherit (path)
    components
    exists
    extensions
    isAbsolute
    name
    relativeTo
    stem
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertNull
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

  extensions = {
    no_extension = assertEqual {
      actual = extensions "some_file";
      expected = [ ];
    };

    consider_hidden_files = assertEqual {
      actual = extensions ".hidden_file";
      expected = [ ];
    };

    relative_path = assertEqual {
      actual = extensions "./../flake.lock";
      expected = [ "lock" ];
    };

    absolute_path = assertEqual {
      actual = extensions "/var/cache/db.sqlite";
      expected = [ "sqlite" ];
    };

    multiple_extensions = assertEqual {
      actual = extensions "project-master.tar.gz";
      expected = [ "tar" "gz" ];
    };

    parent_dir = assertEqual {
      actual = extensions "..";
      expected = [ ];
    };
  };

  isAbsolute = {
    path = assertTrue isAbsolute ./fixtures/example-project;
    string_empty = assertFalse isAbsolute "";
    string_absolute = assertTrue isAbsolute "/var/root";
    string_relative = assertFalse isAbsolute ".git/config";
  };

  name = {
    absolute_dir = assertEqual {
      actual = name "/usr/bin/";
      expected = "bin";
    };

    relative_file = assertEqual {
      actual = name "tmp/foo.txt";
      expected = "foo.txt";
    };

    skip_current_dir = assertEqual {
      actual = name "foo.txt/.";
      expected = "foo.txt";
    };

    skip_empty_components = assertEqual {
      actual = name "foo.txt/.//";
      expected = "foo.txt";
    };

    considers_parent_dir = assertNull name "foo.txt/..";

    root = assertNull name "/";
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

  stem = {
    absolute_dir = assertEqual {
      actual = stem "/usr/bin/";
      expected = "bin";
    };

    relative_file = assertEqual {
      actual = stem "tmp/foo.txt";
      expected = "foo";
    };

    multiple_extensions = assertEqual {
      actual = stem "project/master.tar.gz";
      expected = "master";
    };

    skip_current_dir = assertEqual {
      actual = stem "foo.txt/.";
      expected = "foo";
    };

    skip_empty_components = assertEqual {
      actual = stem "foo.txt/.//";
      expected = "foo";
    };

    considers_parent_dir = assertNull stem "foo.txt/..";

    root = assertNull stem "/";
  };
}
