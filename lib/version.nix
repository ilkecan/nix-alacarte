{ lib, nix-utils }:

let
  inherit (builtins)
    substring
  ;
  inherit (lib)
  ;
  inherit (nix-utils)
  ;
in

rec {
  getUnstableVersion = lastModifiedDate:
    let
      year = substring 0 4 lastModifiedDate;
      month = substring 4 2 lastModifiedDate;
      day = substring 6 2 lastModifiedDate;
    in
    "unstable-${year}-${month}-${day}";
}
