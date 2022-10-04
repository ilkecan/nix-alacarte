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
    mapOr
    notEqualTo
    path
    pipe'
    string
  ;

  inherit (path)
    components
    name
  ;

  extensionsUnsafe = 
    pipe' [
      (string.split ".")
      (list.filter (notEqualTo ""))
      (list.drop 1)
    ];
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
        name
        (mapOr [ ] extensionsUnsafe)
      ];

    isAbsolute = path:
      let
        components' = components path;
      in
      if components' == [ ]
        then false
        else list.head components' == "/";

    name = path:
      let
        last' = pipe path [
          components
          list.last
        ];
      in
      if list.elem last' [ "/" ".." ]
        then null
        else last';

    relativeTo = dir: path:
      dir + "/${toString path}";
  };
}
