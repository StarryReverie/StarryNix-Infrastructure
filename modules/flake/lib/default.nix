{
  config,
  inputs,
  withSystem,
  lib,
  ...
}:
{
  imports = [
    ./profiles

    ./make-node-entry-point.nix
  ];

  options.flake.lib = lib.mkOption {
    type = (lib.types.attrsOf lib.types.anything) // {
      merge =
        loc: defs:
        lib.pipe defs [
          (lib.lists.map ({ value, ... }: value))
          (lib.attrsets.foldAttrs lib.attrsets.recursiveUpdate { })
        ];
    };
  };
}
