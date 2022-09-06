{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    isNull
    notNull
  ;

  inherit (dnm)
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
}
