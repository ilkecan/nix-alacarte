{
  lib,
  nix-alacarte,
  ...
}@args:

let
  inherit (lib)
    flip
  ;

  inherit (nix-alacarte)
    add
    compose
    equalTo
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

  even = compose [ (equalTo 0) (mod' 2) ];

  float = import ./float.nix args;

  increment = add 1;

  int = import ./int.nix args;

  mod = lib.mod;

  mod' = flip mod;

  negate = number:
    -number;

  negative = lessThan' 0;

  odd = compose [ (notEqualTo 0) (mod' 2) ];

  positive = greaterThan' 0;

  sub = builtins.sub;

  sub' = flip sub;
}
