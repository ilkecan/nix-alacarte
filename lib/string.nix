{ lib, nix-utils }:

let
  inherit (builtins)
    concatStringsSep
  ;

  inherit (lib)
    splitString
  ;
in

{
  lines = splitString "\n";

  unlines = concatStringsSep "\n";
}
