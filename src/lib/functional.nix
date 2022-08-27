{
  lib,
  nix-utils,
  ...
}:

let
  inherit (lib)
    foldr
    flip
  ;

  inherit (nix-utils)
    callWith
  ;
in

{
  compose = fs: val:
    foldr (flip callWith) val fs;
}
