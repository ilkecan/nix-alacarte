{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    filter
    readFile
    sort
  ;

  inherit (lib)
    hasInfix
    stringAsChars
  ;

  inherit (nix-alacarte)
    lessThan
    string
  ;

  inherit (nix-alacarte.string)
    intersperse
    split
  ;
in

{
  getCmakeVersion = file:
    let
      content = readFile file;
      lines = split "\n" content;
      versionLines = filter (hasInfix "_VERSION_") lines;
      sortedVersionLines = sort lessThan versionLines;
      isDigit = c: c >= "0" && c <= "9";
      filterDigits = stringAsChars (c: if isDigit c then c else "");
      versionNumbers = map filterDigits sortedVersionLines;
      version = intersperse "." versionNumbers;
    in
    version;

  getUnstableVersion = lastModifiedDate:
    let
      year = string.slice 0 4 lastModifiedDate;
      month = string.slice 4 6 lastModifiedDate;
      day = string.slice 6 8 lastModifiedDate;
    in
    "unstable-${year}-${month}-${day}";
}
