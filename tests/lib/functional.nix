{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    call
    callWith
    compose
    pipe'
    ternary
  ;

  inherit (dnm)
    assertEqual
  ;

  double = x: 2 * x;
  addFive = x: x + 5;
  subtractNine = x: x - 9;
in

{
  call = assertEqual {
    actual = call (n: n > 2) 4;
    expected = true;
  };

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

  ternary = {
    first_expr = assertEqual {
      actual = ternary (4 < 1) "four" "one";
      expected = "one";
    };

    second_expr = assertEqual {
      actual = ternary (4 < 9) "four" "nine";
      expected = "four";
    };
  };
}
