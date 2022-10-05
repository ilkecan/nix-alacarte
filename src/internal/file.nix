{
  nix-alacarte,
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
in

{
  file = {
    add = append: text: file:
      let
        tempFile = write {
          name = "temp";
          inherit text;
        };
        name = baseNameOf file;
        files = if append then [ file tempFile ] else [ tempFile file ];
      in
      concat name files;
  };
}
