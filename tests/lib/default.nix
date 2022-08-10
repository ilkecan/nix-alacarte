{
  inputs,
  system,
  lib ? inputs.nixpkgs.lib,
  nix-utils ? inputs.self.outputs.libs.${system},
}:

let
  inherit (builtins)
    concatStringsSep
    filter
  ;

  inherit (lib)
    flatten
    mapAttrsToList
  ;

  inherit (nix-utils)
    filesOf
  ;

  testFiles = filesOf ./. {
    excludedPaths = [ ./data ./default.nix ];
  };
  importTest = file:
    import file {
      inherit
        lib
        nix-utils
      ;
    };

  testBlocks = map importTest testFiles;

  testPassed = { expr, expected }:
    expr == expected;
  testCases = map (testBlock:
    mapAttrsToList (testName: testCase: {
      name = testName;
      passed = testPassed testCase;
    }) testBlock
  ) testBlocks;
  testCasesFlattened = flatten testCases;

  failedTestCases = filter ({ name, passed }: !passed) testCasesFlattened;
  failedTestNames = map ({ name, passed }: name) failedTestCases;

  sep = "\n - ";
in

if failedTestNames == [ ] then
  "All tests passed.\n"
else
  "Following tests failed: ${sep}${concatStringsSep sep failedTestNames}\n"
