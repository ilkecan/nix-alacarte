{
  inputs,
  system,

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
