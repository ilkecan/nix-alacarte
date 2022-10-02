{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    clamp
    equalTo
    greaterThan
    greaterThan'
    greaterThanOrEqualTo
    greaterThanOrEqualTo'
    lessThan
    lessThan'
    lessThanOrEqualTo
    lessThanOrEqualTo'
    notEqualTo
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  clamp =
    let
      clamp' = clamp 4 10;
    in
    {
      too_low = assertEqual {
        actual = clamp' (-3);
        expected = 4;
      };

      in_range = assertEqual {
        actual = clamp' 5;
        expected = 5;
      };

      too_high = assertEqual {
        actual = clamp' 23;
        expected = 10;
      };
    };

  equalTo = {
    equals = assertTrue equalTo 2 2;
    not_equals = assertFalse equalTo "a" "b";
  };

  greaterThan = {
    equals = assertFalse greaterThan 3.3 3.3;
    less = assertTrue greaterThan 4 2;
    greater = assertFalse greaterThan "a" "b";
  };

  greaterThan' = {
    equals = assertFalse greaterThan' 3.3 3.3;
    less = assertFalse greaterThan' 4 2;
    greater = assertTrue greaterThan' "a" "b";
  };

  greaterThanOrEqualTo = {
    equals = assertTrue greaterThanOrEqualTo 3.3 3.3;
    less = assertTrue greaterThanOrEqualTo 4 2;
    greater = assertFalse greaterThanOrEqualTo "a" "b";
  };

  greaterThanOrEqualTo' = {
    equals = assertTrue greaterThanOrEqualTo' 3.3 3.3;
    less = assertFalse greaterThanOrEqualTo' 4 2;
    greater = assertTrue greaterThanOrEqualTo' "a" "b";
  };

  lessThan = {
    equals = assertFalse lessThan 3.3 3.3;
    less = assertFalse lessThan 4 2;
    greater = assertTrue lessThan "a" "b";
  };

  lessThan' = {
    equals = assertFalse lessThan' 3.3 3.3;
    less = assertTrue lessThan' 4 2;
    greater = assertFalse lessThan' "a" "b";
  };

  lessThanOrEqualTo = {
    equals = assertTrue lessThanOrEqualTo 3.3 3.3;
    less = assertFalse lessThanOrEqualTo 4 2;
    greater = assertTrue lessThanOrEqualTo "a" "b";
  };

  lessThanOrEqualTo' = {
    equals = assertTrue lessThanOrEqualTo' 3.3 3.3;
    less = assertTrue lessThanOrEqualTo' 4 2;
    greater = assertFalse lessThanOrEqualTo' "a" "b";
  };

  notEqualTo = {
    equals = assertTrue notEqualTo [ 2 ] 2;
    not_equals = assertFalse notEqualTo { v = 2; } { v = 2; };
  };
}
