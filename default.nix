{ lib }:

let
  inherit (builtins)
    attrNames
    attrValues
    filter
    genericClosure
    isAttrs
    mapAttrs
    substring
    tryEval
  ;
  inherit (lib)
    filterAttrs
    flatten
    foldl
    forEach
    getAttrs
    hasPrefix
    hasSuffix
    makeSearchPath
    mapAttrs'
    nameValuePair
    optionals
    unique
  ;

  wrap = drv: { key = drv.outPath; inherit drv; };
  unwrap = { key, drv }: drv;

  isDependencyKey = key: hasPrefix "deps" key || hasSuffix "Inputs" key;
  getDependencies = drv: attrValues (filterAttrs (key: _: isDependencyKey key) drv.drvAttrs);
  reduceToDerivations = deps: unique (filter isAttrs (flatten deps));

  getClosure = drvs:
    let
      closure = genericClosure {
        startSet = map wrap drvs;
        operator = e: map wrap (reduceToDerivations (getDependencies (unwrap e)));
      };
    in
    map unwrap closure;

  hasDebugInfo = drv: drv ? separateDebugInfo && drv.separateDebugInfo;

  createDebugSymbolsSearchPath = pkgs: drvs:
    let
      inherit (pkgs) stdenv;
      inherit (stdenv) isLinux;

      defaultBuildInputs = optionals isLinux [ stdenv.glibc ];

      runtimeDependencies = defaultBuildInputs ++ getClosure drvs;
      debuggableDependencies = filter hasDebugInfo runtimeDependencies;
      debugOutputs = map (drv: drv.debug) debuggableDependencies;
      debugSymbolsSearchPath = makeSearchPath "lib/debug" debugOutputs;
    in
    debugSymbolsSearchPath;

  createOverlays = drvs: args:
    mapAttrs
    (name: drv:
      (final: prev: {
        ${name} = drv (final // args);
      })
    )
    drvs;

  getUnstableVersion = lastModifiedDate:
    let
      year = substring 0 4 lastModifiedDate;
      month = substring 4 2 lastModifiedDate;
      day = substring 6 2 lastModifiedDate;
    in
    "unstable-${year}-${month}-${day}";

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
  mergeSets = sets: foldl (l: r: l // r) {} sets;

  createOcamlOverlays = drvs: args:
    mergeSets (forEach ocamlScopeNames (ocamlScopeName:
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

  filterBrokenPackages = packages:
    filterAttrs (_: drv: (tryEval drv.outPath).success) packages;

  getOcamlPackagesFrom = pkgs: packageNames: ocamlScopeName:
    mapAttrs' (name: drv:
      nameValuePair
      "${ocamlScopeName}-${name}"
      drv
    ) (filterBrokenPackages (getAttrs packageNames pkgs.ocaml-ng.${ocamlScopeName}));

  getOcamlPackages = pkgs: packageNames:
    mergeSets (map (getOcamlPackagesFrom pkgs packageNames) ocamlScopeNames);
in
{
  inherit
    createDebugSymbolsSearchPath
    createOcamlOverlays
    createOverlays
    getClosure
    getOcamlPackages
    getOcamlPackagesFrom
    getUnstableVersion
  ;
}
