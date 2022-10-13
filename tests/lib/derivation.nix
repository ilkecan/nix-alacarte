{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    addPassthru
    drv
  ;

  inherit (drv)
    source
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  addPassthru = {
    new_attr = assertEqual {
      actual = addPassthru { test = true; } { passthru = { type = "derivation"; }; };
      expected = { passthru = { type = "derivation"; test = true; }; test = true; };
    };

    overwrite_attr = assertEqual {
      actual = addPassthru { type = "test"; } { passthru = { type = "derivation"; }; };
      expected = { passthru = { type = "test"; }; type = "test"; };
    };
  };

  source = {
    has_src_attr = assertEqual {
      actual = source { src = "<source-drv>"; };
      expected = "<source-drv>";
    };

    does_not_have_src_attr = assertEqual {
      actual = source "<flake-input>";
      expected = "<flake-input>";
    };
  };
}
