{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    boolToInt
    not
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  boolToInt = {
    true = assertEqual {
      actual = boolToInt true;
      expected = 1;
    };

    false = assertEqual {
      actual = boolToInt false;
      expected = 0;
    };
  };

  not = {
    true = assertFalse not true;
    false = assertTrue not false;
  };
}
