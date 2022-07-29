{ nix-utils }:

let
  inherit (nix-utils)
    lines
    unlines
    words
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

  "words" = {
    expr = words "nix repl --file '<nixpkgs>'";
    expected = [ "nix" "repl" "--file" "'<nixpkgs>'" ];
  };

  "unlines_single" = {
    expr = unlines [ "apple" ];
    expected = "apple";
  };

  "unlines_multi" = {
    expr = unlines [ "veni" "vidi" "vici" ];
    expected = "veni\nvidi\nvici";
  };
}
