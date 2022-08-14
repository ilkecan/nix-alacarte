{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    combinators
  ;
in

{
  "and_without_args" = {
    expr = combinators.and [ true false ];
    expected = false;
  };

  "and_with_args" = {
    expr = combinators.and [ (x: y: x + y > 10) (x: y: x < y) (x: y: x * y < 100) ] 4 7;
    expected = true;
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
