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
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = nixpkgs-lib.attrsets.attrValues config.flake.overlays;
        config = {
          allowUnfree = true;
        };
      };
    };
}
