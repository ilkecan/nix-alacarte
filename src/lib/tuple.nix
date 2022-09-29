{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fst
    pair
    snd
  ;

  inherit (nix-alacarte.internal)
    throw
  ;
in
{
  curry = f: x: y:
    f (pair x y);

  fst =
    let
      throw' = throw.appendScope "fst";
    in
    throw'.unlessGetAttr "0";

  pair = x: y:
    { "0" = x; "1" = y; };

  snd =
    let
      throw' = throw.appendScope "snd";
    in
    throw'.unlessGetAttr "1";

  uncurry = f: tuple:
    f (fst tuple) (snd tuple);
}
