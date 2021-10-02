{ lib, nix-utils }:

let
  inherit (builtins)
    filter
    map
  ;
  inherit (lib)
    makeSearchPath
    optionals
  ;
  inherit (nix-utils)
    getClosure
  ;

  hasDebugInfo = drv: drv ? separateDebugInfo && drv.separateDebugInfo;
in

rec {
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
}
