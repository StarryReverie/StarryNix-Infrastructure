{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.desktop.wayfire-environment;
in
{
  config = lib.mkIf customCfg.enable {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        files = [
          {
            file = ".config/wayfire.ini";
            how = "symlink";
          }
        ];
      };
    };
  };
}
