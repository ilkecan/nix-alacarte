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
    getExe
    isDerivation
    isOptionType
  ;

  inherit (nix-alacarte)
    attrs
    fn
    list
    optionalValue
    pair
    str
  ;

  inherit (nix-alacarte.options)
    coerceTo
    default
    mkBool
    mkCoercibleToString
    mkGenericValue
    mkOption
    mkStr
    readOnly
    required
  ;

  inherit (nix-alacarte.internal)
    types
  ;

  inherit (nix-alacarte.internal.options)
    generateOptions
    mkOptionConstructor
    withDefault
  ;

  unsetAttr = fn.compose [ attrs.remove list.singleton ];

  optionAttributes = [
    "apply"
  ];

  setterFunctions = attrs.gen optionAttributes attrs.set;
  unsetterFunctions =
    list.mapToAttrs
      (name: pair "unset${str.capitalize name}" (unsetAttr name))
      optionAttributes
    ;

  setInternal = attrs.set "internal";
  setReadOnly = attrs.set "readOnly";
  setType = attrs.set "type";
  composerFunctions = {
    default = attrs.set "default";
    internal = setInternal true;
    public = setInternal false;
    readOnly = setReadOnly true;
    required = unsetAttr "default";
    writable = setReadOnly false;

    addCheck = check: option:
      setType (types.addCheck option.type check) option;
    between = lowest:
      fn.compose [ setType (types.ints.between lowest) ];

    coerceTo = type: coerceFunc: option:
      let
        setDefault = !option ? default && type.emptyValue ? value;
      in
      option // {
        ${optionalValue setDefault "default"} = type.emptyValue.value;
        type = types.coercedTo option.type coerceFunc type;
      };
    lambda = option:
      let
        default = option.default or option.type.emptyValue.value or null;
      in
      option // {
        ${optionalValue (default != null) "default"} = fn.const default;
        type = types.functionTo option.type;
      };
    list = option:
      let
        apply = option.apply or null;
      in
      option // {
        ${optionalValue (apply != null) "apply"} = list.map apply;
        default = [ ];
        type = types.listOf option.type;
      };
    nonEmptyList = option:
      required option // {
        type = types.nonEmptyListOf option.type;
      };
    optional = option:
      option // {
        default = null;
        type = types.nullOr option.type;
      };
    optionalList = option:
      coerceTo (types.listOf option.type) list.to option;
    attrs = option:
      let
        apply = option.apply or null;
      in
      option // {
        ${optionalValue (apply != null) "apply"} = attrs.map (_: apply);
        default = { };
        type = types.attrsOf option.type;
      };
    unique = option:
      option // {
        type = types.uniq option.type;
      };
  };

  libTypeNames = [
    "bool"
    "either"
    "enum"
    "float"
    "int"
    "oneOf"
    "package"
    "path"
    "port"
    "shellPackage"
    "str"
    "strMatching"
  ];

  option = type:
    if isOptionType type
      then mkOptionConstructor (fn.pipe (lib.mkOption { inherit type; }))
      else fn.compose [ option type ];

  optionFunctions = attrs.concat [
    {
      inherit option;

      # bool
      enable = withDefault [ (default false) ]
        mkBool;
      disable = withDefault [ (default true) ]
        mkBool;

      # str
      exe = arg:
        let
          type = typeOf arg;
          setDefault =
            if isDerivation arg then
              default (getExe arg)
            else
              {
                null = fn.id;
                string = default arg;
              }.${type}
            ;
        in
        withDefault [ setDefault readOnly ]
          mkStr;

      envVars =
        withDefault [ attrs ]
          mkCoercibleToString;
      format = format:
        withDefault [ (default { }) ]
          mkOption format.type;
      line = mkOption types.singleLineStr;
      lines =
        withDefault [ (default "") ]
          mkOption types.lines;
      settings =
        withDefault [ attrs ]
          mkGenericValue;
      submodule =
        withDefault [ (default { }) ]
          mkOption types.submodule;
    }
    (attrs.gen libTypeNames (name: mkOption types.${name}))
    (attrs.map (_: mkOption) types.alacarte)
  ];
in

{
  options = attrs.concat [
    setterFunctions
    unsetterFunctions
    composerFunctions
    (generateOptions optionFunctions)
  ];
}
