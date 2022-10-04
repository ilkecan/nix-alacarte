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
    notEqualTo
    path
    pipe'
    string
  ;

  inherit (path)
    components
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
          (string.split "/")
          (list.ifilter (i: v: !list.elem v componentsToRemove || i == 0))
          (list.imap (i: v: if i == 0 && v == "" then "/" else v))
        ];

    exists = builtins.pathExists;

    extensions =
      pipe' [
        components
        list.last
        (string.split ".")
        (list.filter (notEqualTo ""))
        (list.drop 1)
      ];

    isAbsolute = path:
      let
        components' = components path;
      in
      if components' == [ ]
        then false
        else list.head components' == "/";

    relativeTo = dir: path:
      dir + "/${toString path}";
  };
}
