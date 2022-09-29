{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    flip
  ;

  inherit (nix-alacarte)
    greaterThan
    greaterThanOrEqualTo
    lessThan
    lessThanOrEqualTo
  ;
in

{
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
