{
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    all
  ;

  inherit (nix-alacarte.internal)
    throw'
  ;
in

{
  allEnabled =
    let
      throw'' = throw'.appendScope "allEnabled";
    in
    all (throw''.unlessGetAttr "enable");
}
