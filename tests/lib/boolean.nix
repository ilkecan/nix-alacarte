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
    nand
    nor
    not
    toInt
    toOnOff
    xnor
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

  nand = {
    true_true = assertFalse nand true true;
    true_false = assertTrue nand true false;
    false_true = assertTrue nand false true;
    false_false = assertTrue nand false false;
  };

  nor = {
    true_true = assertFalse nor true true;
    true_false = assertFalse nor true false;
    false_true = assertFalse nor false true;
    false_false = assertTrue nor false false;
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

  xnor = {
    true_true = assertTrue xnor true true;
    true_false = assertFalse xnor true false;
    false_true = assertFalse xnor false true;
    false_false = assertTrue xnor false false;
  };

  xor = {
    true_true = assertFalse xor true true;
    true_false = assertTrue xor true false;
    false_true = assertTrue xor false true;
    false_false = assertFalse xor false false;
  };
}
