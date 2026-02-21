{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.csl or { };
  customCfg = selfCfg.desktop.fcitx5 or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    preservation.preserveAt."/nix/persistence" = {
      users.csl = {
        directories = [
          ".config/fcitx5"
          ".local/share/fcitx5"
        ];
      };
    };
  };
}
