{
  nix-alacarte,
  ...
}@args:

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
  fst =
    let
      throw' = throw.appendScope "fst";
    in
    throw'.unlessGetAttr "0";

  pair = import ./pair.nix args;

  snd =
    let
      throw' = throw.appendScope "snd";
    in
    throw'.unlessGetAttr "1";

  ## inherits

  inherit (pair)
    curry
    uncurry
  ;
}
