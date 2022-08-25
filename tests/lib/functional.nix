{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    compose
  ;

  double = x: 2 * x;
  addFive = x: x + 5;
  subtractNine = x: x - 9;
in

{
  "compose" = {
    expr = compose [ double addFive subtractNine ] 2;
    expected = -4;
  };
}
