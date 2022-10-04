{
  nix-alacarte,
  ...
}@args:

let
  inherit (nix-alacarte)
    attrs
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
      throw'.unlessGetAttr "fst";

    join = separator:
      pipe' [
        attrs.values
        (map toString)
        (string.intersperse separator)
      ];

    pair = import ./pair.nix args;

    singleton = import ./singleton.nix args;

    snd =
      let
        throw' = throw.appendScope "snd";
      in
      throw'.unlessGetAttr "snd";

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
