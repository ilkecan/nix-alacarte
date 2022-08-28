{
  inputs,
  system,
  pkgs ? inputs.nixpkgs.legacyPackages.${system},
  ...
}:

let
  inherit (pkgs)
    concatText
    writeTextFile
  ;

  addToFile = append: text: file:
    let
      tempFile = writeTextFile {
        name = "temp";
        inherit text;
      };
      name = baseNameOf file;
      files = if append then [ file tempFile ] else [ tempFile file ];
    in
    concatText name files;
in

{
  appendToFile = addToFile true;
  prependToFile = addToFile false;
}
