{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    interval
  ;

  inherit (interval)
    contains
    empty
    toString
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  contains =
    let
      start = 4;
      end = 10;
      interval' = interval start end;
    in
    {
      element_less_than_start = assertFalse contains (-4) interval';
      start_is_contained = assertTrue contains start interval';
      element_between = assertTrue contains 8 interval';
      end_is_not_contained = assertFalse contains end interval';
      element_greater_than_end = assertFalse contains 24 interval';
    };

  empty = {
    start_less_than_end = assertFalse empty (interval 2 42);
    start_equals_end = assertTrue empty (interval 5 5);
    start_greater_than_end = assertTrue empty (interval 23 (-4));
  };

  toString = assertEqual {
    actual = toString (interval (-3) 8);
    expected = "[-3, 8)";
  };
}
