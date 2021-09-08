{ lib }:

let
  inherit (builtins)
    attrValues
    filter
    genericClosure
    isAttrs
    mapAttrs
    substring
  ;
  inherit (lib)
    filterAttrs
    flatten
    hasPrefix
    hasSuffix
    makeSearchPath
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
in
{
  inherit
    getClosure
    createDebugSymbolsSearchPath
    createOverlays
    getUnstableVersion
  ;
}
