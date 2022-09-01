{
  inputs,
  system,
  alacarte ? inputs.self.libs.default,
  bootstrap ? inputs.self.bootstrap,
  lib ? inputs.nixpkgs.lib,
  pkgs ? inputs.nixpkgs.legacyPackages.${system},
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
      pkgs
    ;

    alacarte = recursiveUpdate alacarte pkgs-lib // { inherit internal; };
  };

  internal = import ./../lib/internal args';
  pkgs-lib = mergeLibFiles ./. args' { };
in

pkgs-lib
