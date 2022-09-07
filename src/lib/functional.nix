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
    callWith
  ;
in

{
  callWith = val: f:
    f val;

  compose = fs: val:
    foldr (flip callWith) val fs;

  pipe' = flip pipe;
}
