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

  optionalValue = condition: value:
    if condition then
      value
    else
      null
    ;

  unwrapOr = default: value:
    if value == null
      then default
      else value;
}
