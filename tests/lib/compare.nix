{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    equalTo
    notEqualTo
  ;

  inherit (dnm)
    assertFalse
    assertTrue
  ;
in

{
  equalTo = {
    same = assertTrue equalTo 2 2;
    different = assertFalse equalTo "a" "b";
  };

  notEqualTo = {
    different = assertTrue notEqualTo [ 2 ] 2;
    same = assertFalse notEqualTo { v = 2; } { v = 2; };
  };
}
