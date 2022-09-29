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
    greaterThan'
    lessThan'
    negate
    negative
    sub'
  ;
in

{
  abs = number:
    if negative number then negate number else number;

  decrement = sub' 1;

  even = number:
    mod number 2 == 0;

  increment = add 1;

  negate = number:
    -number;

  negative = lessThan' 0;

  odd = number:
    mod number 2 == 1;

  positive = greaterThan' 0;

  sub' = flip sub;
}
