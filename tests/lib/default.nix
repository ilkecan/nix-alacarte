{ lib, nix-utils }:

let
  inherit (builtins)
    attrNames
    concatStringsSep
    filter
    map
    readDir
  ;
  inherit (lib)
    flatten
    mapAttrsToList
    subtractLists
  ;

  testPassed = { expr, expected }:
    expr == expected;

  files = attrNames (readDir ./.);
  nonTestFiles = [
    "data"
    "default.nix"
  ];
  testFiles = subtractLists nonTestFiles files;
  testBlocks = map (f: import "${toString ./.}/${f}" { inherit nix-utils; }) testFiles;

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
