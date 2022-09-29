{
  nix-alacarte,
  ...
}:

let
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

  snd =
    let
      throw'' = throw'.appendScope "snd";
    in
    throw''.unlessGetAttr "1";
}
