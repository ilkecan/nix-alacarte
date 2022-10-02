{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    equalTo
    notEqualTo
  ;
in

{
  isNull = equalTo null;

  notNull = notEqualTo null;

  unwrapOr = default: value:
    if value == null
      then default
      else value;
}
