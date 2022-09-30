{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    mapAttrs
    removeAttrs
    typeOf
  ;

  inherit (lib)
    const
    genAttrs
    getExe
    id
    isDerivation
    isOptionType
    nameValuePair
    pipe
    toList
  ;

  inherit (nix-alacarte)
    capitalize
    compose
    mapListToAttrs
    mergeListOfAttrs
    optionalValue
    setAttr
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
    set
  ;

  inherit (nix-alacarte.internal.options)
    generateOptions
    mkOptionConstructor
    withDefault
  ;

  types = lib.types // { alacarte = nix-alacarte.types; };

  unsetAttr = name: set:
    removeAttrs set [ name ];

  optionAttributes = [
    "apply"
  ];

  setterFunctions = genAttrs optionAttributes setAttr;
  unsetterFunctions =
    mapListToAttrs
      (name: nameValuePair "unset${capitalize name}" (unsetAttr name))
      optionAttributes
    ;

  composerFunctions = {
    default = setAttr "default";
    internal = setAttr "internal" true;
    public = setAttr "internal" false;
    readOnly = setAttr "readOnly" true;
    required = unsetAttr "default";
    writable = setAttr "readOnly" false;

    addCheck = check: option:
      setAttr "type" (types.addCheck option.type check) option;
    between = lowest: highest:
      setAttr "type" (types.ints.between lowest highest);

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
        ${optionalValue (default != null) "default"} = const default;
        type = types.functionTo option.type;
      };
    list = option:
      let
        apply = option.apply or null;
      in
      option // {
        ${optionalValue (apply != null) "apply"} = map apply;
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
      coerceTo (types.listOf option.type) toList option;
    set = option:
      let
        apply = option.apply or null;
      in
      option // {
        ${optionalValue (apply != null) "apply"} = mapAttrs (_: apply);
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
      then mkOptionConstructor (pipe (lib.mkOption { inherit type; }))
      else compose [ option type ];

  optionFunctions = mergeListOfAttrs [
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
                null = id;
                string = default arg;
              }.${type}
            ;
        in
        withDefault [ setDefault readOnly ]
          mkStr;

      envVars =
        withDefault [ set ]
          mkCoercibleToString;
      format = format:
        withDefault [ (default { }) ]
          mkOption format.type;
      line = mkOption types.singleLineStr;
      lines =
        withDefault [ (default "") ]
          mkOption types.lines;
      settings =
        withDefault [ set ]
          mkGenericValue;
      submodule =
        withDefault [ (default { }) ]
          mkOption types.submodule;
    }
    (genAttrs libTypeNames (name: mkOption types.${name}))
    (mapAttrs (_: mkOption) types.alacarte)
  ];
in

{
  options = mergeListOfAttrs [
    setterFunctions
    unsetterFunctions
    composerFunctions
    (generateOptions optionFunctions)
  ];
}
