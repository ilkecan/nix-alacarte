{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    float
  ;

  self = float;
in

{
  float = {
    INFINITY = 1.0e308 * 2;
    NAN = self.INFINITY + self.NEG_INFINITY;
    NEG_INFINITY = -self.INFINITY;
  };
}
