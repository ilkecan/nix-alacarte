{
  inputs ? { },
  system ? "",

  dnm ? inputs.dnm.lib,
  lib ? inputs.nixpkgs.lib,
  nix-alacarte ? inputs.self.lib,
  pkgs ? inputs.nixpkgs.legacyPackages.${system},
}:

let
  inherit (dnm)
    runTests
  ;

  args = {
    inherit
      dnm
      lib
      nix-alacarte
      pkgs
    ;
  };
in

runTests { } ./. args
