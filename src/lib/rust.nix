{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    importTOML
    nameValuePair
  ;

  inherit (nix-alacarte)
    mapListToAttrs
  ;
in

{
  importCargoLock = directory:
    let
      cargoLock = importTOML "${toString directory}/Cargo.lock";
    in
    mapListToAttrs (p: nameValuePair p.name p) cargoLock.package;

  importCargoToml = directory:
    importTOML "${toString directory}/Cargo.toml";
}
