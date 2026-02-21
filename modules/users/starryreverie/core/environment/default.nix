{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.core.environment or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".config/environment.d" ];
      };
    };
  };
}
