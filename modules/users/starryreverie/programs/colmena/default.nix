{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.colmena or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        ((inputs.colmena.overlays.default pkgs pkgs).colmena.override {
          nix-eval-jobs = lixPackageSets.latest.nix-eval-jobs;
        })
      ];
    };
  };
}
