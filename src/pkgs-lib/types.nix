{
  inputs,
  system,

  nix-alacarte,
  lib,

  wrapPackage ? inputs.overlayln.libs.${system}.wrapPackage,
  ...
}:

let
  inherit (lib)
    const
    getValues
    isFunction
    mkDefault
    mkMerge
    mkOptionType
  ;

  inherit (nix-alacarte)
    attrs
    combinators
    fn
    list
    options
  ;

  inherit (nix-alacarte.internal)
    types
  ;

  inherit (nix-alacarte.internal.types')
    prefixArg
    prefixContentsArg
    prefixEachArg
    toPackageSubmoduleConfig
    toPackageSubmoduleDef
  ;
in
{
  types = {
    overrideAttrsArgs = mkOptionType {
      name = "overrideAttrs args";
      check = isFunction;
      merge = const getValues;
    };

    packageSubmodule = default:
      types.submodule (
        args:
        let
          cfg = args.config;

          overrideAttrs = drv:
            list.foldl' (drv: drv.overrideAttrs) drv cfg.overrideAttrs;
          override = drv:
            drv.override cfg.override;
          wrap = drv:
            let
              wrapArgs = attrs.removeNulls cfg.wrap;
            in
            wrapPackage drv wrapArgs;
        in
        {
          options = with options; {
            drv = package;

            wrap = mkSubmodule {
              options = {
                exePath = mkStr [ optional ];

                argv0 = mkStr [ optional ];
                inheritArgv0 = enable;

                set = mkStr [ attrs ];
                setDefault = mkStr [ attrs ];
                unset = mkStr [ list ];

                chdir = mkStr [ optional ];
                run = mkStr [ list ];

                addFlags = mkStr [ list ];
                appendFlags = mkStr [ list ];

                prefix = mkOption prefixArg [ list ];
                suffix = mkOption prefixArg [ list ];
                prefixEach = mkOption prefixEachArg [ list ];
                suffixEach = mkOption prefixEachArg [ list ];
                prefixContents = mkOption prefixContentsArg [ list ];
                suffixContents = mkOption prefixContentsArg [ list ];
              };
            } [ optional ];

            override = mkOption types.alacarte.genericValue [ attrs optional ];

            overrideAttrs = mkOption types.alacarte.overrideAttrsArgs [ optional ];

            final = mkPackage [ internal readOnly ];
          };

          config = mkMerge [
            (mkDefault default)
            {
              final = fn.pipe cfg.drv [
                (if cfg.overrideAttrs != null then overrideAttrs else fn.id)
                (if cfg.override != null then override else fn.id)
                (if cfg.wrap != null then wrap else fn.id)
              ];
            }
          ];
        }
    );

    smartPackage = default:
      let
        packageSubmodule =
          types.alacarte.packageSubmodule (toPackageSubmoduleConfig default);
      in
      mkOptionType {
        name = "smartPackage";
        check = combinators.or [ types.package.check packageSubmodule.check ];
        merge = loc: defs:
          let
            defs' = map toPackageSubmoduleDef defs;
            package = packageSubmodule.merge loc defs';
          in
          package.final;
      };
  };
}
