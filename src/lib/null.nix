{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    equals
    notEquals
  ;
in

{
  isNull = equals null;
  notNull = notEquals null;
}
