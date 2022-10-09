{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    typeOf
  ;

  inherit (lib)
    getValues
    mergeEqualOption
    mkOptionType
  ;

  inherit (lib.strings)
    isCoercibleToString
  ;

  inherit (nix-alacarte)
    allEqual
    attrs
    list
    mkToString
    unwords
  ;

  inherit (nix-alacarte.internal)
    types
  ;
in

{
  types = {
    coercibleToString = coerceFunctions:
      let
        self = mkOptionType {
          name = "coercibleToString";
          check = x:
            attrs.has (typeOf x) coerceFunctions || isCoercibleToString x;
          merge = loc: defs:
            let
              values = getValues defs;
              valueTypes = list.map typeOf values;
              toString = mkToString coerceFunctions;
            in
            if allEqual valueTypes then
              {
                list = (types.listOf self).merge;
                set = (types.attrsOf self).merge;  # maybe this should also be mergeEqualOption?
              }.${list.head valueTypes} or mergeEqualOption loc defs
            else
              types.string.merge
                loc
                (list.map (def: def // { value = toString def.value; }) defs)
            ;
        };
      in
      self;

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
        ] // {
          description = "genericValue";
        };
      in
      type;

    words = with types; (coercedTo (listOf str) unwords str);
  };
}
