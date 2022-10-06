{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    isType
  ;

  inherit (nix-alacarte)
    attrs
    compose
    list
    str
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
      attrs.concat [
        (attrs.map (_name: toOption) optionFunctions)
        (attrs.rename (name: _value: "mk${str.capitalize name}") optionFunctions)
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
