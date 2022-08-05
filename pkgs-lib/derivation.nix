{
  lib,
  makeWrapper,
  nix-utils,
  runCommandLocal,
}:

let
  inherit (builtins)
    baseNameOf
  ;

  inherit (lib)
    escapeShellArg
    mapAttrsToList
    optionalString
    toList
  ;

  inherit (nix-utils.lib)
    unwords
  ;

  inherit (nix-utils.lib.letterCase)
    camelToKebab
  ;

  format = {
    arg = name: value: "--${name} ${escapeShellArg value}";
    flag = name: enabled: optionalString enabled "--${name}";
    listOfArgs = name: values:
      let
        args = map (format.arg name) (toList values);
      in
      unwords args;
    attrsOfArgs = argName: values:
      let
        formatArg = name: value:
          "--${argName} ${escapeShellArg name} ${escapeShellArg value}";
        args = mapAttrsToList formatArg values;
      in
      unwords args;
    listOfArgAttrs = indices: argName: argValues:
      let
        formatValues = values:
          let
            values' =
              mapAttrsToList (_: name: "${escapeShellArg values.${name}}") indices;
          in
          unwords values';
        args = map (values: "--${argName} ${formatValues values}") argValues;
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

  formatArgs = with format; {
    argv0 = arg;
    inheritArgv0 = flag;

    set = attrsOfArgs;
    setDefault = attrsOfArgs;
    unset = listOfArgs;

    chdir = arg;
    run = listOfArgs;

    addFlags = arg;
    appendFlags = arg;

    prefix = listOfArgAttrs argValueIndices.prefix;
    suffix = listOfArgAttrs argValueIndices.prefix;
    prefixEach = listOfArgAttrs argValueIndices.prefixEach;
    suffixEach = listOfArgAttrs argValueIndices.prefixEach;
    prefixContents = listOfArgAttrs argValueIndices.prefixContents;
    suffixContents = listOfArgAttrs argValueIndices.prefixContents;
  };
in

{
  wrapExecutable = exe: {
    outPath ? "",
    name ? baseNameOf (if outPath == "" then exe else outPath),

    argv0 ? null,
    inheritArgv0 ? null,

    set ? null,
    setDefault ? null,
    unset ? null,

    chdir ? null,
    run ? null,

    addFlags ? null,
    appendFlags ? null,

    prefix ? null,
    suffix ? null,
    prefixEach ? null,
    suffixEach ? null,
    prefixContents ? null,
    suffixContents ? null,
  }@args:
  let
    env = { nativeBuildInputs = [ makeWrapper ]; };
    outPath' = if outPath == "" then "$out" else "$out/${outPath}";

    args' = removeAttrs args [
      "name"
      "outPath"
    ];
    arguments = mapAttrsToList (name: value:
      optionalString (value != null) (formatArgs.${name} (camelToKebab name) value)
    ) args';
  in
  runCommandLocal name env ''
    mkdir --parents ${dirOf outPath'}
    makeWrapper ${exe} ${outPath'} ${toString arguments}
  '';
}
