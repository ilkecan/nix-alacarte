{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    combinators
    concatListOfLists
  ;
in

{
  "mkCombinator" = {
    expr = combinators.mkCombinator concatListOfLists [ (x: [ 1 2 x ]) (y: [ y 4 5 ]) ] 3;
    expected = [ 1 2 3 3 4 5 ];
  };

  "and_empty" = {
    expr = combinators.and [ ];
    expected = true;
  };

  "and_without_args" = {
    expr = combinators.and [ true false ];
    expected = false;
  };

  "and_with_args" = {
    expr = combinators.and [ (x: y: x + y > 10) (x: y: x < y) (x: y: x * y < 100) ] 4 7;
    expected = true;
  };

  "or_empty" = {
    expr = combinators.or [ ];
    expected = false;
  };

  "or_without_args" = {
    expr = combinators.or [ true false ];
    expected = true;
  };

  "or_with_args" = {
    expr = combinators.or [ (x: y: x + y > 10) (x: y: x < y) (x: y: x * y < 100) ] 4 2;
    expected = true;
  };
}
