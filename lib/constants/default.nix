{
  bootstrap,
  ...
}@args:

let
  inherit (bootstrap) mergeLibDirectory;
in

mergeLibDirectory ./. args
