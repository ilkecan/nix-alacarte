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
}
