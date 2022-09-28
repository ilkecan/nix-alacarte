{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    equalTo
    greaterThan
    greaterThanOrEqualTo
    lessThan
    lessThanOrEqualTo
    notEqualTo
  ;

  inherit (dnm)
    assertFalse
    assertTrue
  ;
in

{
  equalTo = {
    equals = assertTrue equalTo 2 2;
    not_equals = assertFalse equalTo "a" "b";
  };

  greaterThan = {
    equals = assertFalse greaterThan 3.3 3.3;
    less = assertFalse greaterThan 4 2;
    greater = assertTrue greaterThan "a" "b";
  };

  greaterThanOrEqualTo = {
    equals = assertTrue greaterThanOrEqualTo 3.3 3.3;
    less = assertFalse greaterThanOrEqualTo 4 2;
    greater = assertTrue greaterThanOrEqualTo "a" "b";
  };

  lessThan = {
    equals = assertFalse lessThan 3.3 3.3;
    less = assertTrue lessThan 4 2;
    greater = assertFalse lessThan "a" "b";
  };

  lessThanOrEqualTo = {
    equals = assertTrue lessThanOrEqualTo 3.3 3.3;
    less = assertTrue lessThanOrEqualTo 4 2;
    greater = assertFalse lessThanOrEqualTo "a" "b";
  };

  notEqualTo = {
    equals = assertTrue notEqualTo [ 2 ] 2;
    not_equals = assertFalse notEqualTo { v = 2; } { v = 2; };
  };
}
