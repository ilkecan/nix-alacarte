{ nix-utils }:

let
  inherit (nix-utils)
    lines
    unlines
  ;
in

{
  "lines_single" = {
    expr = lines "apple";
    expected = [ "apple" ];
  };

  "lines_multi" = {
    expr = lines "veni\nvidi\nvici";
    expected = [ "veni" "vidi" "vici" ];
  };

  "unlines_single" = {
    expr = unlines [ "apple" ];
    expected = "apple";
  };

  "unlines_multi" = {
    expr = unlines [ "veni" "vidi" "vici" ];
    expected = "veni\nvidi\nvici";
  };
}
