{
  lib,
  ...
}:

let
  inherit (lib)
    types
  ;
in

{
  types = {
    genericValue =
      let
        type = with types; oneOf [
          bool
          int
          float
          str
          path
          (attrsOf type)
          (listOf type)
        ];
      in
      type;
  };
}
