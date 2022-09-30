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

  compose = fs: val:
    foldr call val fs;

  pipe' = flip pipe;
}
