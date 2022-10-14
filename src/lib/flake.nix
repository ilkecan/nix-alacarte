{
  inputs,

  lib,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    attrs
    dirToAttrs
    fn
    list
  ;
in

{
  patchInputs = inputs': patchesDir: systems:
    let
      patchesFor = fn.pipe patchesDir [
        dirToAttrs
        (attrs.map (_: attrs.values))
        (attrs.filter (_: list.notEmpty))
      ];
    in
    attrs.gen systems (system:
      let
        inherit (inputs.nixpkgs.legacyPackages.${system}) applyPatches;
      in
      inputs' // attrs.forEach patchesFor (inputName: patches:
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
