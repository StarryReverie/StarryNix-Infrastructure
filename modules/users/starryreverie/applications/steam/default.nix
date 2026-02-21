{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.steam or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [
          ".local/share/Steam"
          ".steam"
        ];
      };
    };
  };
}
