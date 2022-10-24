{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    getValues
    removeSuffix
  ;

  inherit (nix-alacarte)
    attrs
    fn
    list
    optionalValue
    pair
    type
  ;

  inherit (nix-alacarte.letterCase)
    kebabToCamel
  ;

  inherit (nix-alacarte.internal)
    throw
  ;
in

{
  addPassthru = passthru: drv:
    let
      drv' = attrs.concat [
        drv
        (list.toAttrs outputList)
        passthru
        {
          ${optionalValue (drv ? all) "all"} = getValues outputList;
          passthru = drv.passthru or { } // passthru;
        }
      ];

      outputList = list.forEach (drv.outputs or [ ]) (name:
        let
          value = drv' // {
            inherit (drv.${name})
              drvPath
              outPath
              outputName
              passthru
              type
            ;
            outputSpecified = true;
          };
        in
        pair name value
      );
    in drv';

  drv =
    let
      throw' = throw.appendScope "drv";
    in
    {
      makeOverridable =
        let
          throw'' = throw'.appendScope "makeOverridable";

          mkOverrideWith = prev: new:
            let
              final = prev // (
                if type.isFn new then
                  let
                    new' = new prev;
                  in
                  if type.isFn new'
                    then new final prev
                    else new'
                else new
              );
            in
            final;

          transformResult = result:
            {
              lambda = fn.toAttrs;
              set = fn.id;
            }.${type.of result} or (
              throw''
                "function to make overridable must return an attribute set or a function"
            ) result;

          emptyOverride = {
            __names = [ ];
          };
        in
        name: f:
          let
            self = innerArgs:
              let
                self' = args:
                  let
                    result = f args;
                    result' =
                      if attrs.empty innerArgs
                        then result
                        else result.override innerArgs;
                    overrideWith = mkOverrideWith args;
                    override = result.override or emptyOverride;
                    names = override.__names;
                  in
                  transformResult result' // {
                    override = override // {
                      __functor = _: args:
                        self (attrs.remove [ name ] args) (overrideWith args.${name} or { });
                      __names = names ++ [ name ];
                      ${name} = fn.compose [ self' overrideWith ];
                    } // attrs.gen names (name:
                      args':
                        self (innerArgs // { ${name} = innerArgs.${name} or { } // args'; }) args
                    );
                  };
              in
              self';
          in
          self { };

      source = drv:
        drv.src or drv;
    };

  mkOverlay = args: drvFuncFile:
    (final: _prev: {
      ${kebabToCamel (removeSuffix ".nix" (baseNameOf drvFuncFile))} =
          final.callPackage drvFuncFile args;
    });
}
