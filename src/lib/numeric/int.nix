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
  # https://github.com/NixOS/nix/blob/0e54fab0dd7b65c777847d6e80f1ca11233a15eb/src/libexpr/value.hh#L68
  MAX = 9223372036854775807;
  MIN = -9223372036854775807 - 1;

  toFloat = mul 1.0;
}
