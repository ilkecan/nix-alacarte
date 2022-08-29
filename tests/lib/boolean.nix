{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    boolToInt
  ;
in

{
  "boolToInt_true" = {
    expr = boolToInt true;
    expected = 1;
  };

  "boolToInt_false" = {
    expr = boolToInt false;
    expected = 0;
  };
}
