{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    float
  ;

  inherit (float)
    INFINITY
    NAN
    NEG_INFINITY
    isFinite
    toString
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  isFinite = {
    nan = assertFalse isFinite NAN;
    negative_infinity = assertFalse isFinite NEG_INFINITY;
    positive_infinity = assertFalse isFinite INFINITY;

    integer = assertTrue isFinite 4;
    negative = assertTrue isFinite (-4.2);
    positive = assertTrue isFinite 4.2;
    zero = assertTrue isFinite 0.0;
  };

  toString = assertEqual {
    actual = toString (-40.123);
    expected = "-40.123000";
  };
}
