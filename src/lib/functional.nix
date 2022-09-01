{
  alacarte,
  lib,
  ...
}:

let
  inherit (lib)
    flip
    foldr
    pipe
  ;

  inherit (alacarte)
    callWith
  ;
in

{
  compose = fs: val:
    foldr (flip callWith) val fs;

  pipe' = flip pipe;
}
