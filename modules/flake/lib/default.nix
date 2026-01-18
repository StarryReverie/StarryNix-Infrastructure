{
  config,
  inputs,
  self,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
in
{
  imports = [
    ./profiles

    ./make-node-entry-point.nix
  ];

  options.flake.lib = nixpkgs-lib.mkOption {
    type = (nixpkgs-lib.types.attrsOf nixpkgs-lib.types.anything) // {
      merge =
        loc: defs:
        nixpkgs-lib.pipe defs [
          (nixpkgs-lib.lists.map ({ value, ... }: value))
          (nixpkgs-lib.attrsets.foldAttrs nixpkgs-lib.attrsets.recursiveUpdate { })
        ];
    };
  };
}
