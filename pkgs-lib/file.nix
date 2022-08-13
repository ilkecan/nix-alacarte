{
  inputs,
  system,
  nix-utils,
  pkgs ? inputs.nixpkgs.legacyPackages.${system},
  ...
}:

let
  inherit (nix-utils)
    concatFiles
  ;

  inherit (pkgs)
    runCommandLocal
    writeTextFile
  ;

  addTo = append: file: text:
    let
      tempFile = writeTextFile {
        name = "temp";
        inherit text;
      };
    in
    concatFiles {
      name = baseNameOf file;
      files = if append then [ file tempFile ] else [ tempFile file ];
    };
in

{
  concatFiles =
    {
      files,
      name ? "concatenated-files",
      ...
    }@args:
    let
      env = args // {
        passAsFile = [ "files" ];
      };
    in
    runCommandLocal name env ''
      cat $(cat $filesPath) > $out
    '';

  appendTo = addTo true;
  prependTo = addTo false;
}
