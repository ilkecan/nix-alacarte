{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    string
  ;
in

{
  mkCpanUrl = author: pname: version:
    let
      authorId = "${string.slice 0 1 author}/${string.slice 0 2 author}/${author}";
    in
    "mirror://cpan/authors/id/${authorId}/${pname}-${version}.tar.gz";
}
