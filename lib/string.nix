{ lib, nix-utils }:

let
  inherit (builtins)
    concatStringsSep
  ;

  inherit (lib)
    splitString
  ;
in

rec {
  lines = splitString "\n";

  unlines = concatStringsSep "\n";
}
