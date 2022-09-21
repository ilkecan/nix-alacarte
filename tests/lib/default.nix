let
  missingDependantOf =
    import ./../../submodules/missing-dependant-of.nix/default.nix {
      inputs = [
        "dnm"
        "lib"
        "nix-alacarte"
        "pkgs"
      ];

      system = [
        "pkgs"
      ];
    };
in

{
  inputs ? missingDependantOf.inputs,
  system ? missingDependantOf.system,

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
