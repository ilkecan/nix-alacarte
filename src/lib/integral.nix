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
  ;
in

{
  increment = add 1;
  decrement = flip sub 1;
}
