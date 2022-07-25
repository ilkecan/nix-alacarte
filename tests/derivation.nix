{ nix-utils }:

let
  inherit (nix-utils)
    sourceOf
  ;
in

{
  "sourceOf_src_attr" = {
    expr = sourceOf { src = "<source-drv>"; };
    expected = "<source-drv>";
  };

  "sourceOf_no_src_attr" = {
    expr = sourceOf "<flake-input>";
    expected = "<flake-input>";
  };
}
