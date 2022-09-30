{
  inputs,

  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    attrValues
    mapAttrs
  ;

  inherit (lib)
    filterAttrs
    genAttrs
    pipe
  ;

  inherit (nix-alacarte)
    dirToAttrs
    forEachAttr
    list
  ;
in

{
  patchInputs = inputs': patchesDir: systems:
    let
      patchesFor = pipe patchesDir [
        dirToAttrs
        (mapAttrs (_: attrValues))
        (filterAttrs (_: list.notEmpty))
      ];
    in
    genAttrs systems (system:
      let
        inherit (inputs.nixpkgs.legacyPackages.${system}) applyPatches;
      in
      inputs' // forEachAttr patchesFor (inputName: patches:
        let
          input = inputs'.${inputName};
          # TODO: use fetchTree after https://github.com/NixOS/nix/pull/6530 is merged
          # args = flakeLock.nodes.${inputName}.original // {
          #   inherit patches;
          # };
          # patchedInput = builtins.fetchTree args;
          patchedInput = applyPatches {
            name = inputName;
            src = input;
            inherit patches;
          };
          flake = import "${patchedInput}/flake.nix";
          self = flake.outputs inputs;
          inputs = { inherit self; } // input.inputs;
          sourceInfo = input.sourceInfo // { inherit (patchedInput) outPath; };
        in
        self // sourceInfo // {
          outputs = self;
          inherit inputs sourceInfo;
        }
      )
    );
}
