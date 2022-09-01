{
  dnm,
  alacarte,
  ...
}:

let
  inherit (alacarte)
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
  compose = assertEqual {
    actual = compose [ double addFive subtractNine ] 2;
    expected = -4;
  };

  pipe' = assertEqual {
    actual = pipe' [ double subtractNine addFive ] 5;
    expected = 6;
  };
}
