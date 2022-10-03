{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    importTOML
  ;

  inherit (nix-alacarte)
    list
    pair
  ;
in

{
  importCargoLock = directory:
    let
      cargoLock = importTOML "${toString directory}/Cargo.lock";
    in
    list.mapToAttrs (p: pair p.name p) cargoLock.package;

  importCargoToml = directory:
    importTOML "${toString directory}/Cargo.toml";
}
