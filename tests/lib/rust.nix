{
  dnm,
  alacarte,
  ...
}:

let
  inherit (alacarte)
    importCargoLock
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  importCargoLock = assertEqual {
    actual = importCargoLock ./fixtures/example-project;
    expected = {
      aho-corasick = {
        checksum = "1e37cfd5e7657ada45f742d6e99ca5788580b5c529dc78faf11ece6dc702656f";
        dependencies = [ "memchr" ];
        name = "aho-corasick";
        source = "registry+https://github.com/rust-lang/crates.io-index";
        version = "0.7.18";
      };
      ansi_term = {
        checksum = "ee49baf6cb617b853aa8d93bf420db2383fab46d314482ca2803b40d5fde979b";
        dependencies = [ "winapi" ];
        name = "ansi_term";
        source = "registry+https://github.com/rust-lang/crates.io-index";
        version = "0.11.0";
      };
    };
  };
}
