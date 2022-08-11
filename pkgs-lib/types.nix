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
    mkDefault
    mkMerge
    mkOptionType
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
          opt = args.options;

          wrapArgs = removeNullAttrs cfg.wrap;
          wrapped = wrapPackage cfg.drv wrapArgs;
          pkg = if opt.wrap.highestPrio != 1500 then wrapped else cfg.drv;
        in
        {
          options = with options; {
            drv = package;
            wrap = submodule {
              options = {
                exePath = nullOrStr;

                argv0 = nullOrStr;
                inheritArgv0 = enable;

                set = attrsOfStr;
                setDefault = attrsOfStr;
                unset = listOfStr;

                chdir = nullOrStr;
                run = lines;

                addFlags = listOfStr;
                appendFlags = listOfStr;

                prefix = mkListOf prefixArg;
                suffix = mkListOf prefixArg;
                prefixEach = mkListOf prefixEachArg;
                suffixEach = mkListOf prefixEachArg;
                prefixContents = mkListOf prefixContentsArg;
                suffixContents = mkListOf prefixContentsArg;
              };
            };

            final = package // {
              internal = true;
              readOnly = true;
            };
          };

          config = mkMerge [
            (mkDefault default)
            {
              final = addPassthru {
                exe = getExe pkg;
              } pkg;
            }
          ];
        }
    );
  };
}
