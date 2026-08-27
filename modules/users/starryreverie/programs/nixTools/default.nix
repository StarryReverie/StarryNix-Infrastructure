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
      packages = with pkgs; [
        (nil.override { nix = config.nix.package; })
        (nixpkgs-review.override { nix = config.nix.package; })
        dix
        nix-diff
        nix-output-monitor
        nix-tree
      ];
    };
  };
}
