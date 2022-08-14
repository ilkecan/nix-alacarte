{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    callWith
  ;
in

{
  "callWith" = {
    expr = callWith 5 (n: n + 10);
    expected = 15;
  };
}
