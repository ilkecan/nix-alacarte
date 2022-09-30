{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    pipe
  ;

  inherit (nix-alacarte)
    list
    path
  ;

  inherit (nix-alacarte.string)
    split
  ;
in
  
{
  path = {
    __functor = _:
      builtins.path;

    components = path:
      let
        componentsToRemove = [ "." "" ];
      in
      if path == ""
        then [ ]
        else pipe path [
          (split "/")
          (list.ifilter (i: v: !list.elem v componentsToRemove || i == 0))
          (list.imap (i: v: if i == 0 && v == "" then "/" else v))
        ];

    exists = builtins.pathExists;

    isAbsolute = path':
      let
        components = path.components path';
      in
      if components == [ ]
        then false
        else list.head components == "/";
  };
}
