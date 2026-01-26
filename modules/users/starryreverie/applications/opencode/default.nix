{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.opencode;
in
{
  config = lib.mkIf customCfg.enable {
    users.users.starryreverie = {
      maid = {
        packages = with pkgs; [ opencode ];
      };
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [
          ".config/opencode"
          ".local/share/opencode"
          ".local/state/opencode"
        ];
      };
    };
  };
}
