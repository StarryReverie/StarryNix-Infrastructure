{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.nixTools or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = [
        (pkgs.nixpkgs-review.override { nix = config.nix.package; })
        pkgs.dix
        pkgs.nil
        pkgs.nix-diff
        pkgs.nix-output-monitor
        pkgs.nix-tree
      ];
    };
  };
}
