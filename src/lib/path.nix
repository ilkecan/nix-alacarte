{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    add
    equalTo
    fn
    list
    mapOr
    path
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
        else fn.pipe path [
          (str.split "/")
          (list.ifilter (i: v: !list.elem v componentsToRemove || i == 0))
          (list.imap (i: v: if i == 0 && v == "" then "/" else v))
        ];

    exists = builtins.pathExists;

    extensions =
      fn.pipe' [
        self.name
        (mapOr [ ] extensionsUnsafe)
      ];

    hasExtension = extension: path:
      let
        extension' = list.to extension;
        extensionLength = list.length extension';

        extensions = self.extensions path;
      in
      fn.pipe extensions [
        list.length
        (sub' extensionLength)
        (fn.flip list.drop extensions)
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
        last' = fn.pipe path [
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
      mapOr null (fn.pipe extensions [
        (list.map str.length)
        list.sum
        (add (list.length extensions))
        (sub nameLength)
        str.take
      ]) name;
  };
}
