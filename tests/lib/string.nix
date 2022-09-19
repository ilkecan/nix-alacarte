{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    addPrefix
    addSuffix
    capitalize
    commands
    uncommands
    concatString
    elements
    unelements
    fmtValue
    indentBy
    indentByWith
    lines
    unlines
    repeat
    splitStringAt
    words
    unwords
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

  concatString = assertEqual {
    actual = concatString "foo" "bar";
    expected = "foobar";
  };

  elements = assertEqual {
    actual = elements "apple,orange";
    expected = [ "apple" "orange" ];
  };

  unelements = assertEqual{
    actual = unelements [ "apple" "orange" ];
    expected = "apple,orange";
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

  splitStringAt = {
    left_and_right_non_empty = assertEqual {
      actual = splitStringAt 3 "fooBar";
      expected = { left = "foo"; right = "Bar"; };
    };

    right_empty = assertEqual {
      actual = splitStringAt 3 "fo";
      expected = { left = "fo"; right = ""; };
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
