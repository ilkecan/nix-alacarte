{
  inputs,
  bootstrap ? inputs.self.bootstrap,
  lib ? inputs.nixpkgs.lib,
}@args:

let
  inherit (bootstrap)
    mergeLibFiles
  ;

  args' = args // {
    inherit
      bootstrap
      lib

      internal
      nix-utils
    ;
  };

  internal = import ./internal args';
  nix-utils = mergeLibFiles ./. args' { };
in

nix-utils
