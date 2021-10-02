{ lib, nix-utils }:

let
  inherit (builtins)
    map
  ;
  inherit (lib)
    foldl
    importTOML
  ;
  inherit (nix-utils)
  ;
in

rec {
  mapListToAttrs = f: list:
    mergeAttrs (map f list);

  mergeAttrs = sets:
    foldl (l: r: l // r) {} sets;
}
