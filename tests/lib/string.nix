{
  dnm,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    substring
  ;

  inherit (lib)
    hasPrefix
  ;

  inherit (nix-alacarte)
    addPrefix
    addSuffix
    capitalize
    commands
    elements
    fmtValue
    indentBy
    indentByWith
    int
    lines
    pair
    repeat
    string
    uncommands
    unelements
    unlines
    unwords
    words
  ;

  inherit (string)
    concat
    concatMap
    find
    rfind
    replace
    split
    splitAt
  ;

  inherit (nix-alacarte.letterCase)
    camelToKebab
    camelToSnake
    kebabToCamel
    kebabToSnake
    snakeToCamel
    snakeToKebab
  ;

  inherit (dnm)
    assertEqual
    assertNull
  ;
in

{
  addPrefix = assertEqual {
    actual = addPrefix "foo" "bar";
    expected = "foobar";
  };

  addSuffix = assertEqual {
    actual = addSuffix "bar" "foo";
    expected = "foobar";
  };

  capitalize = assertEqual {
    actual = capitalize "hellO";
    expected = "HellO";
  };

  commands = assertEqual {
    actual = commands "touch a;ls -al";
    expected = [ "touch a" "ls -al" ];
  };

  uncommands = assertEqual {
    actual = uncommands [ "touch a" "ls -al" ];
    expected = "touch a;ls -al";
  };

  elements = assertEqual {
    actual = elements "apple,orange";
    expected = [ "apple" "orange" ];
  };

  unelements = assertEqual{
    actual = unelements [ "apple" "orange" ];
    expected = "apple,orange";
  };

  concat = assertEqual {
    actual = concat [ "foo" "bar" "baz" ];
    expected = "foobarbaz";
  };

  concatMap = assertEqual {
    actual = concatMap (s: "${s}, ") [ "foo" "bar" "baz" ];
    expected = "foo, bar, baz, ";
  };

  find = {
    nonexisting = assertNull find "a" "bbc";

    prefix = assertEqual {
      actual = find "foo" "foobar";
      expected = 0;
    };

    suffix = assertEqual {
      actual = find "bar" "foobar";
      expected = 3;
    };

    middle = assertEqual {
      actual = find "arb" "foobarbaz";
      expected = 4;
    };

    multiple = assertEqual {
      actual = find "ba" "foobarbaz";
      expected = 3;
    };

    lambda_pattern = assertEqual {
      actual = find (str: i: hasPrefix "AR" (substring i int.MAX str)) "foObARbAz";
      expected = 4;
    };
  };

  rfind = {
    nonexisting = assertNull rfind "a" "bbc";

    prefix = assertEqual {
      actual = rfind "foo" "foobar";
      expected = 0;
    };

    suffix = assertEqual {
      actual = rfind "bar" "foobar";
      expected = 3;
    };

    middle = assertEqual {
      actual = rfind "arb" "foobarbaz";
      expected = 4;
    };

    multiple = assertEqual {
      actual = rfind "ba" "foobarbaz";
      expected = 6;
    };

    lambda_pattern = assertEqual {
      actual = rfind (str: i: hasPrefix "AR" (substring i int.MAX str)) "foObARbAz";
      expected = 4;
    };
  };


  fmtValue = {
    default = assertEqual {
      actual = fmtValue { } true;
      expected = "1";
    };

    custom = assertEqual {
      actual = fmtValue { bool = v: if v then "yes" else "no"; } true;
      expected = "yes";
    };
  };

  indentBy = {
    single_line = assertEqual {
      actual = indentBy 4 "alice";
      expected = "    alice";
    };

    multiline = assertEqual {
      actual = indentBy 2 "  if this then\n    that\n  end";
      expected = "    if this then\n      that\n    end";
    };
  };

  indentByWith = assertEqual {
    actual = indentByWith "|" 2 "bob";
    expected = "||bob";
  };

  letterCase = {
    camelToKebab = assertEqual {
      actual = camelToKebab "fooBar";
      expected = "foo-bar";
    };

    camelToSnake = assertEqual {
      actual = camelToSnake "fooBar";
      expected = "foo_bar";
    };

    kebabToCamel = assertEqual {
      actual = kebabToCamel "foo-bar";
      expected = "fooBar";
    };

    kebabToSnake = assertEqual {
      actual = kebabToSnake "foo-bar";
      expected = "foo_bar";
    };

    snakeToCamel = assertEqual {
      actual = snakeToCamel "foo_bar";
      expected = "fooBar";
    };

    snakeToKebab = assertEqual {
      actual = snakeToKebab "foo_bar";
      expected = "foo-bar";
    };
  };

  lines = {
    single = assertEqual {
      actual = lines "apple";
      expected = [ "apple" ];
    };

    lines_multi = assertEqual {
      actual = lines "veni\nvidi\nvici";
      expected = [ "veni" "vidi" "vici" ];
    };
  };

  unlines = {
    single = assertEqual {
      actual = unlines [ "apple" ];
      expected = "apple";
    };

    multi = assertEqual {
      actual = unlines [ "veni" "vidi" "vici" ];
      expected = "veni\nvidi\nvici";
    };
  };

  repeat = assertEqual {
    actual = repeat 4 " |";
    expected = " | | | |";
  };

  replace =
    let
      plural = replace [ "y" ] [ "ies" ];
    in
    {
      no_change = assertEqual {
        actual = plural "apple";
        expected = "apple";
      };

      changed = assertEqual {
        actual = plural "fly";
        expected = "flies";
      };
    };

  split = {
    separator_does_not_exist = assertEqual {
      actual = split "/" "192.168.1.1";
      expected = [ "192.168.1.1" ];
    };

    separator_exists = assertEqual {
      actual = split "." "192.168.1.1";
      expected = [ "192" "168" "1" "1" ];
    };
  };

  splitAt = {
    negative_index = assertEqual {
      actual = splitAt (-4) "fo";
      expected = pair "" "fo";
    };

    index_too_large = assertEqual {
      actual = splitAt 3 "fo";
      expected = pair "fo" "";
    };

    index_in_range = assertEqual {
      actual = splitAt 3 "fooBar";
      expected = pair "foo" "Bar";
    };
  };

  words = assertEqual {
    actual = words "nix repl --file '<nixpkgs>'";
    expected = [ "nix" "repl" "--file" "'<nixpkgs>'" ];
  };

  unwords = assertEqual {
    actual = unwords [ "nix" "repl" "--file" "'<nixpkgs>'" ];
    expected = "nix repl --file '<nixpkgs>'";
  };
}
