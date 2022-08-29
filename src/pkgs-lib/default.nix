{
  inputs,
  system,
  bootstrap ? inputs.self.bootstrap,
  lib ? inputs.nixpkgs.lib,
  nix-utils ? inputs.self.libs.default,
}@args:

let
  inherit (lib)
    recursiveUpdate
  ;

  inherit (bootstrap)
    mergeLibFiles
  ;

  args' = args // {
    inherit
      bootstrap
      lib

      internal
    ;

    nix-utils = recursiveUpdate nix-utils pkgs-lib;
  };

  internal = import ./../lib/internal args';
  pkgs-lib = mergeLibFiles ./. args';
in

pkgs-lib
