{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    mul
  ;
in

{
  toFloat = mul 1.0;
}
