{ lib, nix-utils }:

let
  inherit (builtins)
    mapAttrs
  ;
  inherit (lib)
  ;
  inherit (nix-utils)
  ;
in

rec {
  createOverlays = drvs: args:
    mapAttrs
    (name: drv:
      (final: prev: {
        ${name} = drv (final // args);
      })
    )
    drvs;
}
