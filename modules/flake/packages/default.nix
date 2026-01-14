{
  config,
  inputs,
  withSystem,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = inputs.nixpkgs.lib.attrsets.attrValues config.flake.overlays;
        config = {
          allowUnfree = true;
        };
      };
    };
}
