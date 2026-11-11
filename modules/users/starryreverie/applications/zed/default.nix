{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.zed or { };
in
{
  config = {
    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = [
        pkgs.zed-editor
      ];

      file.xdg_config."zed/settings.json".source = ./settings.jsonc;
      file.xdg_config."zed/keymap.json".source = ./keymap.jsonc;
    };

    preservation.preserveAt."/nix/persistence" = lib.mkIf (customCfg.enable or false) {
      users.starryreverie = {
        directories = [
          ".local/share/zed"
        ];
      };
    };

    custom.users.starryreverie = {
      applications.zsh = lib.mkIf (customCfg.enable or false) {
        shellAliases = {
          z = "zeditor";
        };
      };
    };
  };
}
