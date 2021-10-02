{ lib, nix-utils }:

let
  inherit (builtins)
    map
    filterAttrs
    tryEval
  ;
  inherit (lib)
    mapAttrs'
    nameValuePair
    getAttrs
    foldl
  ;
  inherit (nix-utils)
    forEach
    mergeAttrs
  ;

  # nix-instantiate --json --eval --expr 'with import <nixpkgs> {}; builtins.filter (lib.hasPrefix "ocamlPackages") (builtins.attrNames ocaml-ng)' | jq
  ocamlScopeNames = [
    "ocamlPackages"
    "ocamlPackages_4_00_1"
    "ocamlPackages_4_01_0"
    "ocamlPackages_4_02"
    "ocamlPackages_4_03"
    "ocamlPackages_4_04"
    "ocamlPackages_4_05"
    "ocamlPackages_4_06"
    "ocamlPackages_4_07"
    "ocamlPackages_4_08"
    "ocamlPackages_4_09"
    "ocamlPackages_4_10"
    "ocamlPackages_4_11"
    "ocamlPackages_4_12"
    "ocamlPackages_latest"
  ];

  filterBrokenPackages = packages:
    filterAttrs (_: drv: (tryEval drv.outPath).success) packages;
in

rec {
  getOcamlPackagesFrom = pkgs: packageNames: ocamlScopeName:
    mapAttrs' (name: drv:
      nameValuePair
      "${ocamlScopeName}-${name}"
      drv
    ) (filterBrokenPackages (getAttrs packageNames pkgs.ocaml-ng.${ocamlScopeName}));

  getOcamlPackages = pkgs: packageNames:
    mergeAttrs (map (getOcamlPackagesFrom pkgs packageNames) ocamlScopeNames);

  createOcamlOverlays = drvs: args:
    mergeAttrs (forEach ocamlScopeNames (ocamlScopeName:
      mapAttrs' (name: drv:
        nameValuePair
          "${ocamlScopeName}-${name}"
          (final: prev: {
            ocaml-ng = prev.ocaml-ng // {
              ${ocamlScopeName} = prev.ocaml-ng.${ocamlScopeName}.overrideScope'
                (final': prev': {
                  ${name} = drv (final // { ocamlPackages = final'; } // args);
                });
            };
          })
      ) drvs
    ));
}
