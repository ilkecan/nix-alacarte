{
  inputs ? assert false; "must be called with either 'inputs' or all of [ 'bootstrap' 'lib' ]",

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
