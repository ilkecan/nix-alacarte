{
  inputs,
  system,
  lib,
  nix-utils,
  overlayln-lib ? inputs.overlayln.libs.${system},
  ...
}:

let
  inherit (lib)
    getExe
    id
    mkDefault
    mkMerge
    mkOptionType
    pipe
  ;

  inherit (nix-utils)
    addPassthru
    options
    removeNullAttrs
  ;

  inherit (overlayln-lib)
    wrapPackage
  ;

  types = lib.types // nix-utils.types;

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
    smartPackage = default:
      let
        packageSubmodule = types.packageSubmodule (toPackageSubmoduleConfig default);
      in
      mkOptionType {
        name = "(package -> )packageSubmodule -> package";
        check = x:
          types.package.check x || packageSubmodule.check x;
        merge = loc: defs:
          let
            defs' = map toPackageSubmoduleDef defs;
            package = packageSubmodule.merge loc defs';
          in
          package.final;
      };

    packageSubmodule = default:
      types.submodule (
        args:
        let
          cfg = args.config;

          override = drv:
            drv.override cfg.override;
          wrap = drv:
            let
              wrapArgs = removeNullAttrs cfg.wrap;
            in
            wrapPackage drv wrapArgs;
          addExe = drv:
            addPassthru {
              exe = getExe drv;
            } drv;
        in
        {
          options = with options; {
            drv = package;

            wrap = mkSubmodule {
              options = {
                exePath = mkStr [ optional ];

                argv0 = mkStr [ optional ];
                inheritArgv0 = enable;

                set = mkStr [ set ];
                setDefault = mkStr [ set ];
                unset = mkStr [ list ];

                chdir = mkStr [ optional ];
                run = lines;

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

            final = mkPackage [
              internal
              readOnly
            ];
          };

          config = mkMerge [
            (mkDefault default)
            {
              final = pipe cfg.drv [
                (if cfg.override != null then override else id)
                (if cfg.wrap != null then wrap else id)
                addExe
              ];
            }
          ];
        }
    );
  };
}
