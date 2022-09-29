{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elem
    head
    pathExists
  ;

  inherit (lib)
    pipe
    splitString
  ;

  inherit (nix-alacarte)
    ifilter
    imap
    path
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
          (splitString "/")
          (ifilter (i: v: !elem v componentsToRemove || i == 0))
          (imap (i: v: if i == 0 && v == "" then "/" else v))
        ];

    exists = pathExists;

    isAbsolute = path':
      let
        components = path.components path';
      in
      if components == [ ]
        then false
        else head components == "/";
  };
}
