{
  lib,
  nix-utils,
  ...
}:

let
  inherit (lib)
    flip
    foldr
    pipe
  ;

  inherit (nix-utils)
    callWith
  ;
in

{
  compose = fs: val:
    foldr (flip callWith) val fs;

  pipe' = flip pipe;
}
