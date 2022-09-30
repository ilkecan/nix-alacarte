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
}
