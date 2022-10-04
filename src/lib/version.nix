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
    list
    str
  ;
in

{
  getCmakeVersion = file:
    let
      content = readFile file;
      lines = str.split "\n" content;
      versionLines = filter (hasInfix "_VERSION_") lines;
      sortedVersionLines = sort lessThan versionLines;
      isDigit = c: c >= "0" && c <= "9";
      filterDigits = stringAsChars (c: if isDigit c then c else "");
      versionNumbers = list.map filterDigits sortedVersionLines;
      version = str.intersperse "." versionNumbers;
    in
    version;

  getUnstableVersion = lastModifiedDate:
    let
      year = str.slice 0 4 lastModifiedDate;
      month = str.slice 4 6 lastModifiedDate;
      day = str.slice 6 8 lastModifiedDate;
    in
    "unstable-${year}-${month}-${day}";
}
