{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.fcitx5 or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [
          ".config/fcitx5"
          ".local/share/fcitx5"
        ];
      };
    };
  };
}
