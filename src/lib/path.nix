{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    flip
    pipe
  ;

  inherit (nix-alacarte)
    add
    equalTo
    list
    mapOr
    path
    pipe'
    str
    sub
    sub'
  ;

  inherit (nix-alacarte.internal.path)
    extensionsUnsafe
  ;

  self = path;
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
        self.name
        (mapOr [ ] extensionsUnsafe)
      ];

    hasExtension = extension: path:
      let
        extension' = list.to extension;
        extensionLength = list.length extension';

        extensions = self.extensions path;
      in
      pipe extensions [
        list.length
        (sub' extensionLength)
        (flip list.drop extensions)
        (equalTo extension')
      ];

    isAbsolute = path:
      let
        components = self.components path;
      in
      if components == [ ]
        then false
        else list.head components == "/";

    name = path:
      let
        last' = pipe path [
          self.components
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
        name = self.name path;
        nameLength = str.length name;
        extensions = extensionsUnsafe name;
      in
      mapOr null (pipe extensions [
        (list.map str.length)
        list.sum
        (add (list.length extensions))
        (sub nameLength)
        str.take
      ]) name;
  };
}
