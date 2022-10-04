{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    str
  ;
in

{
  mkCpanUrl = author: pname: version:
    let
      authorId = "${str.slice 0 1 author}/${str.slice 0 2 author}/${author}";
    in
    "mirror://cpan/authors/id/${authorId}/${pname}-${version}.tar.gz";
}
