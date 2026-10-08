{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  customCfg = config.custom.system.core.nix;
in
{
  config = lib.mkIf customCfg.enable {
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    environment.etc = lib.pipe inputs [
      (lib.flip lib.attrsets.removeAttrs [ "self" ])
      (lib.attrsets.mapAttrsToList (name: flake: { "nix/inputs/${name}".source = flake.outPath; }))
      lib.attrsets.mergeAttrsList
    ];
    nix.settings.nix-path = lib.mkForce [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
  };
}

