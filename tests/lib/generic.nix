{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    mkToString
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  mkToString = {
    default = assertEqual {
      actual = mkToString { } true;
      expected = "1";
    };

    custom = assertEqual {
      actual = mkToString { bool = v: if v then "yes" else "no"; } true;
      expected = "yes";
    };
  };
}
