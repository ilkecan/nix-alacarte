{ lib, nix-utils }:

let
  inherit (builtins)
  ;
  inherit (lib)
    importTOML
  ;
  inherit (nix-utils)
    mapListToAttrs
  ;
in

rec {
  importCargoLock = directory:
    let
      cargoLock = importTOML "${toString directory}/Cargo.lock";
    in
    mapListToAttrs (p: {
      ${p.name} = p;
    }) cargoLock.package;
}
