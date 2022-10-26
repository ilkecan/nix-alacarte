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
    and
    not
    toInt
    toOnOff
    xor
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  and = {
    true_true = assertTrue and true true;
    true_false = assertFalse and true false;
    false_true = assertFalse and false true;
    false_false = assertFalse and false false;
  };

  not = {
    true = assertFalse not true;
    false = assertTrue not false;
  };

  or =
    let
      or' = bool.or;
    in
    {
      true_true = assertTrue or' true true;
      true_false = assertTrue or' true false;
      false_true = assertTrue or' false true;
      false_false = assertFalse or' false false;
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

  xor = {
    true_true = assertFalse xor true true;
    true_false = assertTrue xor true false;
    false_true = assertTrue xor false true;
    false_false = assertFalse xor false false;
  };
}
