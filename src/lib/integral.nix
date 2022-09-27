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

  even = n:
    mod n 2 == 0;

  increment = add 1;

  odd = n:
    mod n 2 == 1;
}
