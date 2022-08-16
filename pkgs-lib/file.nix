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

  addToFile = append: file: text:
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

  appendToFile = addToFile true;
  prependToFile = addToFile false;
}
