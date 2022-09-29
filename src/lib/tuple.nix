{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    pair
  ;

  inherit (nix-alacarte.internal)
    throw'
  ;
in
{
  fst =
    let
      throw'' = throw'.appendScope "fst";
    in
    throw''.unlessGetAttr "0";

  pair = x: y:
    { "0" = x; "1" = y; };

  snd =
    let
      throw'' = throw'.appendScope "snd";
    in
    throw''.unlessGetAttr "1";
}
