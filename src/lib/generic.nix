{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fn
    type
  ;
in

{
  mkToString = {
    bool ? null,
    float ? null,
    int ? null,
    lambda ? null,
    list ? null,
    null ? null,
    path ? null,
    set ? null,
    string ? null,
  }@fs: value:
    let
      fs' = {
        bool = v: if v then "1" else "";
        float = nix-alacarte.float.toString;
        null = fn.const "";
        string = fn.id;
      } // fs;
      toString = fs'.${type.of value} or builtins.toString;
    in
    toString value;
}
