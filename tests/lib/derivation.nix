{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    addPassthru
    sourceOf
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

  sourceOf = {
    has_src_attr = assertEqual {
      actual = sourceOf { src = "<source-drv>"; };
      expected = "<source-drv>";
    };

    does_not_have_src_attr = assertEqual {
      actual = sourceOf "<flake-input>";
      expected = "<flake-input>";
    };
  };
}
