{
  inputs ? assert false; "must be called with either 'inputs' or all of [ 'dnm' 'lib' 'nix-alacarte' ]",
  system ? assert false; "must be called with either 'system' or all of [ 'pkgs' ]",

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
