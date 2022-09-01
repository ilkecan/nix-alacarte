{
  dnm,
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    getUnstableVersion
    getCmakeVersion
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  getUnstableVersion = assertEqual {
    actual = getUnstableVersion "20211002221620";
    expected = "unstable-2021-10-02";
  };

  getCmakeVersion = assertEqual {
    actual = getCmakeVersion ./data/CMakeLists.txt;
    expected = "2.7.3";
  };
}
