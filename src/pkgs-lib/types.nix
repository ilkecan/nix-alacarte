{
  inputs,
  system,

  nix-alacarte,
  lib,

  wrapPackage ? inputs.overlayln.libs.${system}.wrapPackage,
  ...
}:

let
  inherit (builtins)
    foldl'
  ;

  inherit (lib)
    const
    getValues
    id
    isFunction
    mkDefault
    mkMerge
    mkOptionType
    pipe
  ;

  inherit (nix-alacarte)
    combinators
    options
    removeNullAttrs
  ;

  types = lib.types // nix-alacarte.types;

  mkArgType = name:
    types.submodule {
      options = with options; {
        env = str;
        sep = str;
        ${name} = str;
      };
    };

  prefixArg = mkArgType "val";
  prefixEachArg = mkArgType "vals";
  prefixContentsArg = mkArgType "files";

  toPackageSubmoduleConfig = package:
    if types.package.check package then
      { drv = package; }
    else
      package
    ;

  toPackageSubmoduleDef = { file, value }:
    { inherit file; value = toPackageSubmoduleConfig value; };
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
              wrapArgs = removeNullAttrs cfg.wrap;
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

            override = mkOption types.genericValue [
              set
              optional
            ];

            overrideAttrs = mkOption types.overrideAttrsArgs [
              optional
            ];

            final = mkPackage [
              internal
              readOnly
            ];
          };

          config = mkMerge [
            (mkDefault default)
            {
              final = pipe cfg.drv [
                (if cfg.overrideAttrs != null then overrideAttrs else id)
                (if cfg.override != null then override else id)
                (if cfg.wrap != null then wrap else id)
              ];
            }
          ];
        }
    );

    smartPackage = default:
      let
        packageSubmodule = types.packageSubmodule (toPackageSubmoduleConfig default);
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
