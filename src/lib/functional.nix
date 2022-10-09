{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    flip
    foldr
    pipe
  ;

  inherit (nix-alacarte)
    call
  ;
in

{
  call = f: arg:
    f arg;

  callWith = flip call;

  compose = fs: arg:
    foldr call arg fs;

  pipe' = flip pipe;

  ternary = cond: expr1: expr2:
    if cond then expr1 else expr2;

  ternary' = expr1: expr2: cond:
    if cond then expr1 else expr2;
}
