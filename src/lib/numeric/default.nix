{
  lib,
  nix-alacarte,
  ...
}@args:

let
  inherit (nix-alacarte)
    add
    div
    equalTo
    fn
    greaterThan'
    lessThan'
    mod
    mod'
    negate
    negative
    notEqualTo
    sub
    sub'
  ;
in

{
  abs = number:
    if negative number then negate number else number;

  add = builtins.add;

  decrement = sub' 1;

  div = builtins.div;

  div' = fn.flip div;

  even = fn.compose [ (equalTo 0) (mod' 2) ];

  float = import ./float.nix args;

  increment = add 1;

  int = import ./int.nix args;

  mod = lib.mod;

  mod' = fn.flip mod;

  mul = builtins.mul;

  negate = number:
    -number;

  negative = lessThan' 0;

  odd = fn.compose [ (notEqualTo 0) (mod' 2) ];

  positive = greaterThan' 0;

  sub = builtins.sub;

  sub' = fn.flip sub;
}
