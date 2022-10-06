{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    commands
    elements
    fmtValue
    indentBy
    indentByWith
    lines
    pair
    str
    uncommands
    unelements
    unlines
    unwords
    words
  ;

  inherit (str)
    append
    at
    capitalize
    concat
    concat2
    concatMap
    drop
    find
    foldl
    foldr
    lower
    prepend
    replace
    replicate
    rfind
    slice
    split
    splitAt
    take
    upper
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
    assertFailure
    assertNull
  ;
in

{
  append = assertEqual {
    actual = append "bar" "foo";
    expected = "foobar";
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

  at =
    let
      string = "abcde";
    in
    {
      negative_index = {
        out_of_bounds = assertFailure at (-9) string;

        in_range = assertEqual {
          actual = at (-4) string;
          expected = "b";
        };
      };

      positive_index = {
        out_of_bounds = assertFailure at (-9) string;

        in_range = assertEqual {
          actual = at 2 string;
          expected = "c";
        };
      };
    };

  capitalize = assertEqual {
    actual = capitalize "hellO";
    expected = "HellO";
  };

  concat = assertEqual {
    actual = concat [ "foo" "bar" "baz" ];
    expected = "foobarbaz";
  };

  conat2 = assertEqual {
    actual = concat2 "foo" "bar";
    expected = "foobar";
  };

  concatMap = assertEqual {
    actual = concatMap (s: "${s}, ") [ "foo" "bar" "baz" ];
    expected = "foo, bar, baz, ";
  };

  drop =
    let
      string = "abcde";
    in
    {
      negative = assertEqual {
        actual = drop (-2) string;
        expected = string;
      };

      positive = {
        in_range = assertEqual {
          actual = drop 3 string;
          expected = "de";
        };

        out_of_range = assertEqual {
          actual = drop 9 string;
          expected = "";
        };
      };
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
      actual = find (str: i: (slice i (i + 2) str) == "AR") "foObARbAz";
      expected = 4;
    };
  };

  prepend = assertEqual {
    actual = prepend "foo" "bar";
    expected = "foobar";
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
      actual = rfind (str: i: (slice i (i + 2) str) == "AR") "foObARbAz";
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

  foldl = assertEqual {
    actual = foldl (x: y: x + "," + y) "|" "abc";
    expected = "|,a,b,c";
  };

  foldr = assertEqual {
    actual = foldr (x: y: x + "," + y) "|" "abc";
    expected = "a,b,c,|";
  };

  lower = {
    lowercase = assertEqual {
      actual = lower "abc";
      expected = "abc";
    };

    mixed = assertEqual {
      actual = lower "aBC";
      expected = "abc";
    };

    uppercase = assertEqual {
      actual = lower "ABC";
      expected = "abc";
    };
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

  replicate = assertEqual {
    actual = replicate 4 " |";
    expected = " | | | |";
  };

  slice =
    let
      string = "abcde";
    in
    {
      start_is_greater_than_end = assertEqual {
        actual = slice 3 2 string;
        expected = "";
      };

      start_and_end_are_the_same = assertEqual {
        actual = slice 1 1 string;
        expected = "";
      };

      start_is_negative = assertEqual {
        actual = slice (-3) 4 string;
        expected = "cd";
      };

      start_is_negative_out_of_bounds = assertEqual {
        actual = slice (-29) 4 string;
        expected = "abcd";
      };

      end_is_negative = assertEqual {
        actual = slice 1 (-1) string;
        expected = "bcd";
      };

      end_is_out_of_bounds = assertEqual {
        actual = slice 1 22 string;
        expected = "bcde";
      };

      end_is_negative_out_of_bounds = assertEqual {
        actual = slice 3 (-14) string;
        expected = "";
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

  splitAt =
    let
      string = "abcde";
    in
    {
    negative_index = {
      out_of_bounds = assertEqual {
        actual = splitAt (-9) string;
        expected = pair "" string;
      };

      in_range = assertEqual {
        actual = splitAt (-2) string;
        expected = pair "abc" "de";
      };
    };

    positive_index = {
      out_of_bounds = assertEqual {
        actual = splitAt 24 string;
        expected = pair string "";
      };

      in_range = assertEqual {
        actual = splitAt 2 string;
        expected = pair "ab" "cde";
      };
    };
  };

  take =
    let
      string = "abcde";
    in
    {
      negative = assertEqual {
        actual = take (-2) string;
        expected = "";
      };

      positive = {
        in_range = assertEqual {
          actual = take 3 string;
          expected = "abc";
        };

        out_of_range = assertEqual {
          actual = take 9 string;
          expected = string;
        };
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

  upper = {
    lower = assertEqual {
      actual = upper "abc";
      expected = "ABC";
    };

    mixed = assertEqual {
      actual = upper "aBc";
      expected = "ABC";
    };

    uppercase = assertEqual {
      actual = upper "ABC";
      expected = "ABC";
    };
  };
}
