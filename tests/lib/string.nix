{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    commands
    elements
    enclose
    indentBy
    indentBy'
    indentWith
    lines
    mkToString
    pair
    queries
    quote
    str
    uncommands
    unelements
    unlines
    unqueries
    unwords
    words
  ;

  inherit (str)
    append
    at
    capitalize
    chars
    concat
    concat2
    concatMap
    cons
    drop
    empty
    find
    foldl
    foldl'
    foldr
    foldr'
    head
    init
    intercalate
    intercalate2
    intersperse
    last
    lower
    notEmpty
    prepend
    replace
    replicate
    rfind
    singleton
    slice
    split
    splitAt
    tail
    take
    uncons
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
    assertFalse
    assertNull
    assertTrue
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

  chars = {
    empty = assertEqual {
      actual = chars "";
      expected = [ ];
    };

    non_empty = assertEqual {
      actual = chars "abcde";
      expected = [ "a" "b" "c" "d" "e" ];
    };
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

  cons = assertEqual {
    actual = cons "a" "bc";
    expected = "abc";
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

  empty = {
    empty_string = assertTrue empty "";
    non_empty_string = assertFalse empty "bc";
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

  notEmpty = {
    empty_string = assertFalse notEmpty "";
    non_empty_string = assertTrue notEmpty "2c";
  };

  prepend = assertEqual {
    actual = prepend "foo" "bar";
    expected = "foobar";
  };

  queries = assertEqual {
    actual = queries "key1=value1&key2=value2";
    expected = [ "key1=value1" "key2=value2" ];
  };

  quote = assertEqual {
    actual = quote ''ab"c"d'';
    expected = ''"ab"c"d"'';
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

  enclose = assertEqual {
    actual = enclose "(" ")" "24.8 - 3.3";
    expected = "(24.8 - 3.3)";
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

  indentBy' = assertEqual {
    actual = indentBy' "|" 2 "bob";
    expected = "||bob";
  };

  indentWith = assertEqual {
    actual = indentWith (i: line: if i == 0 then "- " else "  ") "a: 2\nb: true\nc: 4.2";
    expected = "- a: 2\n  b: true\n  c: 4.2";
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

  foldl' = assertEqual {
    actual = foldl' (x: y: x + "," + y) "|" "abc";
    expected = "|,a,b,c";
  };

  foldr = assertEqual {
    actual = foldr (x: y: x + "," + y) "|" "abc";
    expected = "a,b,c,|";
  };

  foldr' = assertEqual {
    actual = foldr' (x: y: x + "," + y) "|" "abc";
    expected = "a,b,c,|";
  };

  head = {
    empty_string = assertFailure head "";

    non_empty_string = assertEqual {
      actual = head "0112";
      expected = "0";
    };
  };

  init = {
    empty_string = assertFailure init "";

    non_empty_string = assertEqual {
      actual = init "123";
      expected = "12";
    };
  };

  intercalate = assertEqual {
    actual = intercalate ", " [ "there" "was" "a" "time" ];
    expected = "there, was, a, time";
  };

  intercalate2 = assertEqual {
    actual = intercalate2 " ile " "leyla" "mecnun";
    expected = "leyla ile mecnun";
  };

  intersperse = assertEqual {
    actual = intersperse "0" "2468";
    expected = "2040608";
  };

  last = {
    empty_list = assertFailure last "";

    non_empty_list = assertEqual {
      actual = last "123";
      expected = "3";
    };
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

  mkToString = {
    default = assertEqual {
      actual = mkToString { } true;
      expected = "1";
    };

    custom = assertEqual {
      actual = mkToString { bool = v: if v then "yes" else "no"; } true;
      expected = "yes";
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

  singleton = {
    character = assertEqual {
      actual = singleton "a";
      expected = "a";
    };

    string = assertFailure singleton "abc";
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

  tail = {
    empty_string = assertFailure tail "";

    non_empty_string = assertEqual {
      actual = tail "0112";
      expected = "112";
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

  uncons = {
    empty = assertNull uncons "";

    single_elem = assertEqual {
      actual = uncons "2";
      expected = pair "2" "";
    };

    multi_elems = assertEqual {
      actual = uncons "235";
      expected = pair "2" "35";
    };
  };

  unqueries = assertEqual {
    actual = unqueries [ "key1=value1" "key2=value2" ];
    expected = "key1=value1&key2=value2";
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
