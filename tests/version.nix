{ nix-utils }:

let
  inherit (nix-utils)
    getUnstableVersion
  ;
in

{
  "getUnstableVersion" = {
    expr = getUnstableVersion "20211002221620";
    expected = "unstable-2021-10-02";
  };
}

