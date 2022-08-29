{
  bootstrap,
  ...
}@args:

let
  inherit (bootstrap)
    mergeLibFiles
  ;
in

mergeLibFiles ./. args { }
