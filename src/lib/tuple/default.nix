{
  nix-alacarte,
  ...
}@args:

let
  inherit (nix-alacarte)
    pair
    tuple
  ;

  inherit (nix-alacarte.internal)
    throw
  ;
in

{
  tuple = {
    fst =
      let
        throw' = throw.appendScope "fst";
      in
      throw'.unlessGetAttr "0";

    pair = import ./pair.nix args;

    singleton = import ./singleton.nix args;

    snd =
      let
        throw' = throw.appendScope "snd";
      in
      throw'.unlessGetAttr "1";

    unit = import ./unit.nix args;
  };

  ## inherits
  inherit (pair)
    curry
    swap
    uncurry
  ;

  inherit (tuple)
    fst
    pair
    singleton
    snd
    unit
  ;
}
