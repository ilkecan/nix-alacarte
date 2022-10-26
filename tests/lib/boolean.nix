{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    bool
  ;

  inherit (bool)
    not
    toInt
    toOnOff
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  not = {
    true = assertFalse not true;
    false = assertTrue not false;
  };

  toInt = {
    true = assertEqual {
      actual = toInt true;
      expected = 1;
    };

    false = assertEqual {
      actual = toInt false;
      expected = 0;
    };
  };

  toOnOff = {
    on = assertEqual {
      actual = toOnOff true;
      expected = "on";
    };

    off = assertEqual {
      actual = toOnOff false;
      expected = "off";
    };
  };
}
