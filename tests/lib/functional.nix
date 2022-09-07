{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    callWith
    compose
    pipe'
  ;

  inherit (dnm)
    assertEqual
  ;

  double = x: 2 * x;
  addFive = x: x + 5;
  subtractNine = x: x - 9;
in

{
  callWith = assertEqual {
    actual = callWith 5 (n: n + 10);
    expected = 15;
  };

  compose = assertEqual {
    actual = compose [ double addFive subtractNine ] 2;
    expected = -4;
  };

  pipe' = assertEqual {
    actual = pipe' [ double subtractNine addFive ] 5;
    expected = 6;
  };
}
