{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    flip
    id
    max
    min
  ;

  inherit (nix-alacarte)
    compose
    greaterThan
    greaterThanOrEqualTo
    int
    lessThan
    lessThanOrEqualTo
    unwrapOr
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
        max' = if low == null then id else max low;
      in
      high:
        let
          min' = if high == null then id else min high;
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

  lessThan = builtins.lessThan;

  lessThan' = flip lessThan;

  lessThanOrEqualTo = lhs: rhs:
    lhs <= rhs;

  lessThanOrEqualTo' = flip lessThanOrEqualTo;

  notEqualTo = lhs: rhs:
    lhs != rhs;
}