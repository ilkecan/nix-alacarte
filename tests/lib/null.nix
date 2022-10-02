{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    isNull
    notNull
    unwrapOr
  ;

  inherit (dnm)
    assertEqual
    assertFalse
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
