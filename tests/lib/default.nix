{
  inputs,
  system,
  dnm ? inputs.dnm.lib,
  lib ? inputs.nixpkgs.lib,
  nix-utils ? inputs.self.outputs.libs.${system},
}:

let
  inherit (dnm)
    runTests
  ;

  args = {
    inherit
      dnm
      lib
      nix-utils
    ;
  };
in

runTests ./. args { }
