{
  nix-alacarte,
  pkgs,
  ...
}:

let
  inherit (nix-alacarte)
    attrs
    fn
    str
  ;

  inherit (nix-alacarte.letterCase)
    camelToKebab
  ;

  inherit (nix-alacarte.internal.derivation)
    formatArgs
  ;

  inherit (pkgs)
    makeWrapper
    runCommandLocal
  ;
in

{
  wrapExecutable =
    let
      env = { nativeBuildInputs = [ makeWrapper ]; };
      fmtArg = name: value:
        str.optional (value != null) (formatArgs.${name} (camelToKebab name) value);
      fmtArgs = fn.pipe' [
        (attrs.remove [ "name" "outPath" ])
        (attrs.mapToList fmtArg)
        toString
      ];
    in
    exe: {
      outPath ? "",
      name ? baseNameOf (if outPath == "" then exe else outPath),

      argv0 ? null,
      inheritArgv0 ? false,

      set ? { },
      setDefault ? { },
      unset ? [ ],

      chdir ? null,
      run ? [ ],

      addFlags ? [ ],
      appendFlags ? [ ],

      prefix ? [ ],
      suffix ? [ ],
      prefixEach ? [ ],
      suffixEach ? [ ],
      prefixContents ? [ ],
      suffixContents ? [ ],
    }@args:
    let
      outPath' = "$out/${outPath}";
    in
    runCommandLocal name env ''
      mkdir --parents ${dirOf outPath'}
      makeWrapper ${exe} ${outPath'} ${fmtArgs args}
    '';
}
