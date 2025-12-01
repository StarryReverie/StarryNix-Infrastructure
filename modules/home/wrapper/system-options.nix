{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.wrapping;
in
{
  options = {
    wrapping = {
      pkgs = lib.mkOption {
        type = lib.types.raw;
        description = "The Nixpkgs package set";
      };

      specialArgs = lib.mkOption {
        type = lib.types.attrsOf lib.types.raw;
        description = "Special arguments to pass to the wrapper-manager module";
        default = { };
      };

      modules = lib.mkOption {
        type = lib.types.listOf lib.types.raw;
        description = "Modules of wrapper definitions";
        default = [ ];
      };

      evaluation = lib.mkOption {
        type = lib.types.raw;
        description = "The evaluation result of `wrapper-manager.lib { ... }`";
        readOnly = true;
      };

      packages = lib.mkOption {
        type = lib.types.attrsOf lib.types.raw;
        description = "The resulting wrapper package set";
        readOnly = true;
      };
    };
  };

  config = {
    wrapping = {
      evaluation = inputs.wrapper-manager.lib {
        inherit (cfg) pkgs specialArgs;
        modules = [ { wrappers = { }; } ] ++ cfg.modules;
      };

      packages = cfg.evaluation.config.build.packages;
    };
  };
}
