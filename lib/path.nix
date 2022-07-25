{ lib, nix-utils }:

let
  inherit (builtins)
    substring
  ;
in
  
{
  isAbsolutePath = path:
    substring 0 1 path == "/";
}
