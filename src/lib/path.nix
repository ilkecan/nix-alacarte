{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elem
    substring
  ;

  inherit (lib)
    splitString
  ;

  inherit (nix-alacarte)
    compose
    equalTo
    ifilter
    imap
    pipe'
  ;
in
  
{
  isAbsolutePath = compose [ (equalTo "/") (substring 0 1) ];

  pathComponents =
    let
      componentsToRemove = [ "." "" ];
    in
    pipe' [
      (splitString "/")
      (ifilter (i: v: !elem v componentsToRemove || i == 0))
      (imap (i: v: if i == 0 && v == "" then "/" else v))
    ];
}
