{
  lib,
  nix-alacarte,
  ...
}@args:

let
  inherit (lib)
    flip
    max
    min
  ;

  inherit (nix-alacarte)
    compose
    fn
    greaterThan
    greaterThanOrEqualTo
    lessThan
    lessThanOrEqualTo
  ;

  inherit (nix-alacarte.internal)
    assertion
  ;
in

{
  clamp =
    let
      assertion' = assertion.appendScope "clamp";
    in
    low:
      let
        max' = if low == null then fn.id else max low;
      in
      high:
        let
          min' = if high == null then fn.id else min high;
        in
        assert assertion' (low == null || high == null || low <= high) "`low` cannot be greater than `high`";
        compose [ min' max' ];

  equalTo = lhs: rhs:
    lhs == rhs;

  greaterThan = lhs: rhs:
    lhs > rhs;

  greaterThan' = flip greaterThan;

  greaterThanOrEqualTo = lhs: rhs:
    lhs >= rhs;

  greaterThanOrEqualTo' = flip greaterThanOrEqualTo;

  interval = import ./interval.nix args;

  lessThan = builtins.lessThan;

  lessThan' = flip lessThan;

  lessThanOrEqualTo = lhs: rhs:
    lhs <= rhs;

  lessThanOrEqualTo' = flip lessThanOrEqualTo;

  notEqualTo = lhs: rhs:
    lhs != rhs;
}
