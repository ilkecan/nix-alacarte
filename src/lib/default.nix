{
  inputs ? { },

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
      inputs

      bootstrap
      lib
    ;

    nix-alacarte = nix-alacarte // { inherit internal; };
  };

  nix-alacarte = mergeLibFiles ./. args' { };
  internal = import ./internal args';
in

nix-alacarte
