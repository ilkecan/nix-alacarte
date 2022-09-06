{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    callWith
    equals
    notEquals
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
    same = assertTrue equals 2 2;
    different = assertFalse equals "a" "b";
  };

  notEquals = {
    different = assertTrue notEquals [ 2 ] 2;
    same = assertFalse notEquals { v = 2; } { v = 2; };
  };


}
