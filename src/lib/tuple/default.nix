{
  nix-alacarte,
  ...
}@args:

let
  inherit (builtins)
    attrValues
  ;

  inherit (nix-alacarte)
    pair
    pipe'
    string
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

    join = separator:
      pipe' [
        attrValues
        (map toString)
        (string.intersperse separator)
      ];

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
