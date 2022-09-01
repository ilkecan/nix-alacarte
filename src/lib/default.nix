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
    ;

    alacarte = alacarte // { inherit internal; };
  };

  alacarte = mergeLibFiles ./. args' { };
  internal = import ./internal args';
in

alacarte
