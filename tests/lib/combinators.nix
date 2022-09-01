{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    concatLists
  ;

  inherit (nix-alacarte)
    combinators
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;

  fs = [
    (x: y: x + y > 10)
    (x: y: x < y)
    (x: y: x * y < 100)
  ];
in

{
  mkCombinator = assertEqual {
    actual = combinators.mkCombinator concatLists [ (x: [ 1 2 x ]) (y: [ y 4 5 ]) ] 3;
    expected = [ 1 2 3 3 4 5 ];
  };

  and = {
    empty = assertTrue (combinators.and [ ]);
    without_args = assertFalse (combinators.and [ true false ]);
    with_args = assertTrue (combinators.and fs 4 7);
  };

  or = {
    empty = assertFalse (combinators.or [ ]);
    without_args = assertTrue (combinators.or [ true false ]);
    with_args = assertTrue (combinators.or fs 4 2);
  };
}
