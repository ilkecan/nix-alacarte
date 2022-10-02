{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    isNull
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
