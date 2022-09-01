{
  dnm,
  alacarte,
  ...
}:

let
  inherit (alacarte)
    callWith
    equals
    isNull
    notEquals
    notNull
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  callWith = assertEqual {
    actual = callWith 5 (n: n + 10);
    expected = 15;
  };

  equals = {
    same = assertTrue (equals 2 2);
    different = assertFalse (equals "a" "b");
  };

  notEquals = {
    different = assertTrue (notEquals [ 2 ] 2);
    same = assertFalse (notEquals { v = 2; } { v = 2; });
  };

  isNull = {
    null = assertTrue (isNull null);
    not_null = assertFalse (isNull true);
  };

  notNull = {
    not_null = assertTrue (notNull 4.2);
    null = assertFalse (notNull null);
  };
}
