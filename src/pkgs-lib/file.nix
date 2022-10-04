{
  nix-alacarte,
  pkgs,
  ...
}:

let
  inherit (nix-alacarte)
    file
  ;

  inherit (file)
    concat
    write
  ;

  addToFile = append: text: file:
    let
      tempFile = write {
        name = "temp";
        inherit text;
      };
      name = baseNameOf file;
      files = if append then [ file tempFile ] else [ tempFile file ];
    in
    concat name files;
in

{
  file = {
    append = addToFile true;

    concat = pkgs.concatText;

    prepend = addToFile false;

    write = pkgs.writeTextFile;
  };
}
