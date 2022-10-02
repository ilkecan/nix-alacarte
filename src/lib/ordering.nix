{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    flip
    max
    min
  ;

  inherit (nix-alacarte)
    compose
    greaterThan
    greaterThanOrEqualTo
    lessThan
    lessThanOrEqualTo
  ;
in

{
  clamp = low: high:
    compose [ (min high) (max low) ];

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
