{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    equals
    notEquals
    optionalValue
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertNull
    assertTrue
  ;
in

{
  equals = {
    same = assertTrue equals 2 2;
    different = assertFalse equals "a" "b";
  };

  notEquals = {
    different = assertTrue notEquals [ 2 ] 2;
    same = assertFalse notEquals { v = 2; } { v = 2; };
  };

  optionalValue = {
    true = assertEqual {
      actual = optionalValue true 4;
      expected = 4;
    };

    false = assertNull optionalValue false 23;
  };
}
