{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elem
    hasAttr
  ;

  inherit (lib)
    concatStrings
  ;

  inherit (lib.generators)
    toPretty
  ;

  inherit (nix-alacarte.internal)
    assertMsg'
    colorVariable
    toPretty'
  ;

  inherit (nix-alacarte.ansi.controlFunctions.controlSequences.SGR)
    blue
    bold
    magenta
    reset
  ;

  boldAnd = color: msg:
    concatStrings [ bold color msg reset ];

  blue' = boldAnd blue;
  magenta' = boldAnd magenta;
in

{
  assertAttr = funcName: set: attrName:
    assertMsg' funcName (hasAttr attrName set)
      "attribute `${colorVariable attrName}` missing ${toPretty' set}";

  assertMsg' = name: pred: msg:
    pred || throw "${blue' "nix-alacarte.${name}"}: ${msg}";

  assertOneOf' = funcName: varName: value: list:
    assertMsg' funcName (elem value list)
      "`${colorVariable varName}` is ${toPretty' value} but must be one of ${toPretty' list}";

  colorVariable = magenta';

  toPretty' = toPretty { };
}
