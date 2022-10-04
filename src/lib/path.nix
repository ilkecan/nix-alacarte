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
    add
    list
    mapOr
    notEqualTo
    path
    pipe'
    str
    sub
  ;

  inherit (path)
    components
    name
  ;

  extensionsUnsafe = 
    pipe' [
      (str.split ".")
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
          (str.split "/")
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

    stem = path:
      let
        name' = name path;
        nameLength = str.length name';
        extensions = extensionsUnsafe name';
      in
      mapOr null (pipe extensions [
        (list.map str.length)
        list.sum
        (add (list.length extensions))
        (sub nameLength)
        str.take
      ]) name';
  };
}
