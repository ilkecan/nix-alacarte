{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elem
    head
  ;

  inherit (lib)
    pipe
  ;

  inherit (nix-alacarte)
    ifilter
    imap
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
          (ifilter (i: v: !elem v componentsToRemove || i == 0))
          (imap (i: v: if i == 0 && v == "" then "/" else v))
        ];

    exists = builtins.pathExists;

    isAbsolute = path':
      let
        components = path.components path';
      in
      if components == [ ]
        then false
        else head components == "/";
  };
}
