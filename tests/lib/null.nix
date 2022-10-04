{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    isNull
    mapOr
    mul
    notNull
    optionalValue
    unwrapOr
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertNull
    assertTrue
  ;
in

{
  isNull = {
    null = assertTrue isNull null;
    not_null = assertFalse isNull true;
  };

  mapOr =
    let
      doubleOrZero = mapOr 0 (mul 2);
    in
    {
      not_null = assertEqual {
        actual = doubleOrZero 4;
        expected = 8;
      };

      null = assertEqual {
        actual = doubleOrZero null;
        expected = 0;
      };
    };

  notNull = {
    not_null = assertTrue notNull 4.2;
    null = assertFalse notNull null;
  };

  optionalValue = {
    true = assertEqual {
      actual = optionalValue true 4;
      expected = 4;
    };

    false = assertNull optionalValue false 23;
  };

  unwrapOr =
    let
      unwrapOr' = unwrapOr 24;
    in
    {
      not_null = assertEqual {
        actual = unwrapOr' 2;
        expected = 2;
      };

      null = assertEqual {
        actual = unwrapOr' null;
        expected = 24;
      };
    };
}
