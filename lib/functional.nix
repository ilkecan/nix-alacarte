{
  lib,
  nix-utils,
  ...
}:

let
  inherit (lib)
    foldr
    id
  ;

  inherit (nix-utils)
    compose
  ;
in

{
  compose = f: g: x:
    f (g x);

  composeMany = fs:
    foldr compose id fs;
}
