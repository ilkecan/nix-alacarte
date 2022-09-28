{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    add
    sub
  ;

  inherit (lib)
    flip
    mod
  ;

  inherit (nix-alacarte)
    greaterThan
    lessThan
  ;
in

{
  decrement = flip sub 1;

  even = number:
    mod number 2 == 0;

  increment = add 1;

  negate = number:
    -number;

  negative = lessThan 0;

  odd = number:
    mod number 2 == 1;

  positive = greaterThan 0;
}
