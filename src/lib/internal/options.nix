{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    mapAttrs
  ;

  inherit (lib)
    isType
  ;

  inherit (nix-alacarte)
    capitalize
    compose
    list
    mergeListOfAttrs
    renameAttrs
  ;

  inherit (nix-alacarte.internal.options)
    mkOptionConstructor
    withDefault
  ;

  optionConstructorType = "option-constructor";
  isOptionConstructor = isType optionConstructorType;
  toOption = mkOptionFunction:
    if isOptionConstructor mkOptionFunction
      then mkOptionFunction [ ]
      else compose [ toOption mkOptionFunction ];
in

{
  options = {
    generateOptions = optionFunctions:
      mergeListOfAttrs [
        (mapAttrs (_name: toOption) optionFunctions)
        (renameAttrs (name: _value: "mk${capitalize name}") optionFunctions)
      ];

    mkOptionConstructor = unaryFunction:
      {
        _type = optionConstructorType;
        __functor = _self: unaryFunction;
      };

    withDefault = defaultFs:
      let
        prependDefaultFs = list.prepend defaultFs;
        self = mkOptionFunction:
          if isOptionConstructor mkOptionFunction then
            mkOptionConstructor (compose [ mkOptionFunction prependDefaultFs ])
          else
            compose [ self mkOptionFunction ];
      in
      self;
  };
}
