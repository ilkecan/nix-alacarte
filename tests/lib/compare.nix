{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    equals
    notEquals
  ;

  inherit (dnm)
    assertFalse
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
}
