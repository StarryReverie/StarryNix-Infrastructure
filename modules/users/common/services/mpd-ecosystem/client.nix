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
      selfCfg = config.users.users.${name};
      customCfg = selfCfg.custom.services.mpd-ecosystem;
    in
    {
      options.custom.services.mpd-ecosystem.client = {
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          description = "MPD clients to be added to `$PATH`";
          default = [ ];
          example = lib.literalExpression "[ pkgs.mpc ]";
        };
      };

      config = lib.mkIf customCfg.enable {
        maid = {
          packages = customCfg.client.packages;
        };
      };
    };
in
{
  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customMpdEcosystemSubmodule);
  };
}
