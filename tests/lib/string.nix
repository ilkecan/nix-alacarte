{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    capitalize
    commands
    uncommands
    elements
    unelements
    fmtValue
    lines
    unlines
    repeat
    splitStringAt
    words
    unwords
  ;

  inherit (nix-utils.letterCase)
    camelToKebab
    camelToSnake
    kebabToCamel
    kebabToSnake
    snakeToCamel
    snakeToKebab
  ;
in

{
  "capitalize" = {
    expr = capitalize "hellO";
    expected = "HellO";
  };

  "commands" = {
    expr = commands "touch a;ls -al";
    expected = [ "touch a" "ls -al" ];
  };

  "uncommands" = {
    expr = uncommands [ "touch a" "ls -al" ];
    expected = "touch a;ls -al";
  };

  "elements" = {
    expr = elements "apple,orange";
    expected = [ "apple" "orange" ];
  };

  "unelements" = {
    expr = unelements [ "apple" "orange" ];
    expected = "apple,orange";
  };

  "fmtValue_default" = {
    expr = fmtValue { } true;
    expected = "1";
  };

  "fmtValue_custom" = {
    expr = fmtValue { bool = v: if v then "yes" else "no"; } true;
    expected = "yes";
  };

  "camelToKebab" = {
    expr = camelToKebab "fooBar";
    expected = "foo-bar";
  };

  "camelToSnake" = {
    expr = camelToSnake "fooBar";
    expected = "foo_bar";
  };

  "kebabToCamel" = {
    expr = kebabToCamel "foo-bar";
    expected = "fooBar";
  };

  "kebabToSnake" = {
    expr = kebabToSnake "foo-bar";
    expected = "foo_bar";
  };

  "snakeToCamel" = {
    expr = snakeToCamel "foo_bar";
    expected = "fooBar";
  };

  "snakeToKebab" = {
    expr = snakeToKebab "foo_bar";
    expected = "foo-bar";
  };

  "lines_single" = {
    expr = lines "apple";
    expected = [ "apple" ];
  };

  "lines_multi" = {
    expr = lines "veni\nvidi\nvici";
    expected = [ "veni" "vidi" "vici" ];
  };

  "unlines_single" = {
    expr = unlines [ "apple" ];
    expected = "apple";
  };

  "unlines_multi" = {
    expr = unlines [ "veni" "vidi" "vici" ];
    expected = "veni\nvidi\nvici";
  };

  "repeat" = {
    expr = repeat 4 " |";
    expected = " | | | |";
  };

  "splitStringAt" = {
    expr = splitStringAt 3 "fooBar";
    expected = {
      left = "foo";
      right = "Bar";
    };
  };

  "splitStringAt_right_empty" = {
    expr = splitStringAt 3 "fo";
    expected = {
      left = "fo";
      right = "";
    };
  };

  "words" = {
    expr = words "nix repl --file '<nixpkgs>'";
    expected = [ "nix" "repl" "--file" "'<nixpkgs>'" ];
  };

  "unwords" = {
    expr = unwords [ "nix" "repl" "--file" "'<nixpkgs>'" ];
    expected = "nix repl --file '<nixpkgs>'";
  };
}
