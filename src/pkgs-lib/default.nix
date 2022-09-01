{
  inputs ? assert false; "must be called with either 'inputs' or all of [ 'bootstrap' 'lib' 'nix-alacarte' 'pkgs' ]",
  system ? assert false; "must be called with either 'system' or all of [ 'pkgs' ]",

  bootstrap ? inputs.self.bootstrap,
  lib ? inputs.nixpkgs.lib,
  nix-alacarte ? inputs.self.libs.default,
  pkgs ? inputs.nixpkgs.legacyPackages.${system},
  ...
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

    nix-alacarte = recursiveUpdate nix-alacarte pkgs-lib // { inherit internal; };
  };

  internal = import ./../lib/internal args';
  pkgs-lib = mergeLibFiles ./. args' { };
in

pkgs-lib
