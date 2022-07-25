{ lib, nix-utils }:

let
  inherit (builtins)
    substring
  ;
in

{
  mkCpanUrl = author: pname: version:
    let
      authorId = "${substring 0 1 author}/${substring 0 2 author}/${author}";
    in
    "mirror://cpan/authors/id/${authorId}/${pname}-${version}.tar.gz";
}
