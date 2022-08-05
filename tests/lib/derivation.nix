{ nix-utils }:

let
  inherit (nix-utils.lib)
    addPassthru
    sourceOf
  ;
in

{
  "addPassthru_new_attr" = {
    expr = addPassthru { test = true; } { passthru = { type = "derivation"; }; };
    expected = { passthru = { type = "derivation"; test = true; }; test = true; };
  };

  "addPassthru_overwrite_attr" = {
    expr = addPassthru { type = "test"; } { passthru = { type = "derivation"; }; };
    expected = { passthru = { type = "test"; }; type = "test"; };
  };

  "sourceOf_src_attr" = {
    expr = sourceOf { src = "<source-drv>"; };
    expected = "<source-drv>";
  };

  "sourceOf_no_src_attr" = {
    expr = sourceOf "<flake-input>";
    expected = "<flake-input>";
  };
}
