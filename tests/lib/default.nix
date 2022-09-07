let
  missingDependantOf =
    import ./../../submodules/missing-dependant-of.nix/default.nix {
      inputs = [
        "dnm"
        "lib"
        "nix-alacarte"
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
  nix-alacarte ? inputs.self.libs.${system},
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
    ;
  };
in

runTests ./. args { }
