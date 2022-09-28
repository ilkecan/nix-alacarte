{
  lib,
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
in

{
  decrement = flip sub 1;

  even = number:
    mod number 2 == 0;

  increment = add 1;

  negate = number:
    -number;

  odd = number:
    mod number 2 == 1;
}
