{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    pipe'
    str
    list
    notEqualTo
  ;
in

{
  path = {
    extensionsUnsafe = 
      pipe' [
        (str.split ".")
        (list.filter (notEqualTo ""))
        (list.drop 1)
      ];
  };
}
