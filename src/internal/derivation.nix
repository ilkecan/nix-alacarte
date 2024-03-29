{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    escapeShellArg
  ;

  inherit (nix-alacarte)
    attrs
    fn
    list
    str
    unwords
  ;

  format = {
    arg = name: value:
      "--${name} ${escapeShellArg value}";
    flag = name: enabled:
      str.optional enabled "--${name}";

    listOfArgs = name:
      fn.pipe' [
        list.to
        (list.map (format.arg name))
        unwords
      ];

    attrsOfArgs = argName: values:
      let
        formatArg = name: value:
          "--${argName} ${escapeShellArg name} ${escapeShellArg value}";
        args = attrs.mapToList formatArg values;
      in
      unwords args;
    listOfArgAttrs = indices: argName: argValues:
      let
        formatValues = values:
          let
            values' =
              attrs.mapToList (_: name: "${escapeShellArg values.${name}}") indices;
          in
          unwords values';
        args = list.map (values: "--${argName} ${formatValues values}") argValues;
      in
      unwords args;
  };

  argValueIndices = {
    prefix = {
      "1" = "env";
      "2" = "sep";
      "3" = "val";
    };

    prefixEach = {
      "1" = "env";
      "2" = "sep";
      "3" = "vals";
    };

    prefixContents = {
      "1" = "env";
      "2" = "sep";
      "3" = "files";
    };
  };
in

{
  derivation = {
    formatArgs = with format; {
      argv0 = arg;
      inheritArgv0 = flag;

      set = attrsOfArgs;
      setDefault = attrsOfArgs;
      unset = listOfArgs;

      chdir = arg;
      run = listOfArgs;

      addFlags = listOfArgs;
      appendFlags = listOfArgs;

      prefix = listOfArgAttrs argValueIndices.prefix;
      suffix = listOfArgAttrs argValueIndices.prefix;
      prefixEach = listOfArgAttrs argValueIndices.prefixEach;
      suffixEach = listOfArgAttrs argValueIndices.prefixEach;
      prefixContents = listOfArgAttrs argValueIndices.prefixContents;
      suffixContents = listOfArgAttrs argValueIndices.prefixContents;
    };
  };
}
