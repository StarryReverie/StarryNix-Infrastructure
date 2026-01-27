{
  config,
  lib,
  pkgs,
  ...
}:
let
  customMpdEcosystemSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.services.mpd-ecosystem;
    in
    {
      options.services.mpd-ecosystem.client = {
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          description = "MPD clients to be added to `$PATH`";
          default = [ ];
          example = lib.literalExpression "[ pkgs.mpc ]";
        };
      };
    };

  customMpdEcosystemEffectSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name} or { };
      customCfg = selfCfg.services.mpd-ecosystem or { };
    in
    {
      config = lib.mkIf (customCfg.enable or false) {
        maid = {
          packages = customCfg.client.packages;
        };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customMpdEcosystemSubmodule);
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customMpdEcosystemEffectSubmodule);
  };
}
