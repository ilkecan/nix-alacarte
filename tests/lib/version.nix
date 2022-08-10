{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    getUnstableVersion
    getCmakeVersion
  ;
in

{
  "getUnstableVersion" = {
    expr = getUnstableVersion "20211002221620";
    expected = "unstable-2021-10-02";
  };

  "getCmakeVersion" = {
    expr = getCmakeVersion ./data/CMakeLists.txt;
    expected = "2.7.3";
  };
}
