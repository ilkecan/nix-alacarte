{
  inputs,
  bootstrap ? inputs.self.bootstrap,
  lib ? inputs.nixpkgs.lib,
}@args:

let
  inherit (bootstrap) mergeLibDirectory;

  args' = args // {
    inherit
      bootstrap
      lib

      internal
      nix-utils
    ;
  };

  internal = import ./internal args';
  nix-utils = mergeLibDirectory ./. args';
in
nix-utils
