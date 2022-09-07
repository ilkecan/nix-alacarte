let
  missingDependantOf =
    import ./../../nix/missing-dependant-of.nix/default.nix {
      inputs = [
        "bootstrap"
        "lib"
      ];
    };
in

{
  inputs ? missingDependantOf.inputs,

  bootstrap ? inputs.self.bootstrap,
  lib ? inputs.nixpkgs.lib,
  ...
}@args:

let
  inherit (bootstrap)
    mergeLibFiles
  ;

  args' = args // {
    inherit
      bootstrap
      lib
    ;

    nix-alacarte = nix-alacarte // { inherit internal; };
  };

  nix-alacarte = mergeLibFiles ./. args' { };
  internal = import ./internal args';
in

nix-alacarte
