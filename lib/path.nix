{ lib, nix-utils }:

let
  inherit (builtins)
    substring
  ;
in

rec {
  isAbsolutePath = path:
    substring 0 1 path == "/";
}
