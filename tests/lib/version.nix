{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
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
    actual = getCmakeVersion ./fixtures/example-project/CMakeLists.txt;
    expected = "2.7.3";
  };
}
