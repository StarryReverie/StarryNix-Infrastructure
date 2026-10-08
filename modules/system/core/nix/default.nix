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
    nix.package = pkgs.nixVersions.latest;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ];

    system.nixos.revision = inputs.nixpkgs.rev or inputs.nixpkgs.dirtyRev or null;
    system.nixos.versionSuffix =
      if inputs.nixpkgs ? lastModifiedDate && inputs.nixpkgs ? shortRev then
        ".${builtins.substring 0 8 inputs.nixpkgs.lastModifiedDate}.${inputs.nixpkgs.shortRev}"
      else
        "";
  };
}
