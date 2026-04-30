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
    nix.package = pkgs.lixPackageSets.latest.lix;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nix.settings.substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"

      "https://cache.garnix.io"
      "https://nix-community.cachix.org"
      "https://colmena.cachix.org"
    ];

    nix.settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];

    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ];

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    environment.etc = lib.pipe inputs [
      (lib.flip lib.attrsets.removeAttrs [ "self" ])
      (lib.attrsets.mapAttrsToList (name: flake: { "nix/inputs/${name}".source = flake.outPath; }))
      lib.attrsets.mergeAttrsList
    ];
    nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

    system.nixos.revision = inputs.nixpkgs.rev or inputs.nixpkgs.dirtyRev or null;
    system.nixos.versionSuffix =
      if inputs.nixpkgs ? lastModifiedDate && inputs.nixpkgs ? shortRev then
        ".${builtins.substring 0 8 inputs.nixpkgs.lastModifiedDate}.${inputs.nixpkgs.shortRev}"
      else
        "";
  };
}
