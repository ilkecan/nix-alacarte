{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    compose
    composeMany
  ;

  double = x: 2 * x;
  addFive = x: x + 5;
  subtractNine = x: x - 9;
in

{
  "compose" = {
    expr = compose double addFive 2;
    expected = 14;
  };

  "composeMany" = {
    expr = composeMany [ double addFive subtractNine ] 2;
    expected = -4;
  };
}
