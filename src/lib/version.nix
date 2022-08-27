{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    concatStringsSep
    filter
    lessThan
    readFile
    sort
    substring
  ;

  inherit (lib)
    hasInfix
    splitString
    stringAsChars
  ;
in

{
  getCmakeVersion = file:
    let
      content = readFile file;
      lines = splitString "\n" content;
      versionLines = filter (hasInfix "_VERSION_") lines;
      sortedVersionLines = sort lessThan versionLines;
      isDigit = c: c >= "0" && c <= "9";
      filterDigits = stringAsChars (c: if isDigit c then c else "");
      versionNumbers = map filterDigits sortedVersionLines;
      version = concatStringsSep "." versionNumbers;
    in
    version;

  getUnstableVersion = lastModifiedDate:
    let
      year = substring 0 4 lastModifiedDate;
      month = substring 4 2 lastModifiedDate;
      day = substring 6 2 lastModifiedDate;
    in
    "unstable-${year}-${month}-${day}";
}
