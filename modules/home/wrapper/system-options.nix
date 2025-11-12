{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.wrapperConfigurations;
in
{
  options = {
    wrapperConfigurations = {
      pkgs = lib.mkOption {
        type = lib.types.raw;
        description = "The Nixpkgs package set";
      };

      modules = lib.mkOption {
        type = lib.types.listOf lib.types.raw;
        description = "Modules of wrapper definitions";
        default = [ ];
      };

      evaluationResult = lib.mkOption {
        type = lib.types.raw;
        description = "The evaluation result of `wrapper-manager.lib { ... }`";
        readOnly = true;
      };

      finalPackages = lib.mkOption {
        type = lib.types.attrsOf lib.types.raw;
        description = "The resulting wrapper package set";
        readOnly = true;
      };
    };
  };

  config = {
    wrapperConfigurations = {
      evaluationResult = inputs.wrapper-manager.lib {
        inherit (cfg) pkgs;
        modules = [ { wrappers = { }; } ] ++ cfg.modules;
      };

      finalPackages = cfg.evaluationResult.config.build.packages;
    };
  };
}
