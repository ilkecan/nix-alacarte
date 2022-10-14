{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fn
    list
    notEqualTo
    str
  ;
in

{
  path = {
    extensionsUnsafe = 
      fn.pipe' [
        (str.split ".")
        (list.filter (notEqualTo ""))
        (list.drop 1)
      ];
  };
}
