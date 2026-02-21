{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.telegram-desktop or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ telegram-desktop ];
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/share/TelegramDesktop" ];
      };
    };
  };
}
