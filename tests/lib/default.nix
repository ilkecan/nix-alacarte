{
  inputs,
  system,
  alacarte ? inputs.self.outputs.libs.${system},
  dnm ? inputs.dnm.lib,
  lib ? inputs.nixpkgs.lib,
}:

let
  inherit (dnm)
    runTests
  ;

  args = {
    inherit
      alacarte
      dnm
      lib
    ;
  };
in

runTests ./. args { }
