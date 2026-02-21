{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.lazygit or { };
in
{
  config = {
    custom.users.starryreverie = {
      applications.zsh = lib.mkIf (customCfg.enable or false) {
        shellAliases = {
          lg = "lazygit";
        };
      };
    };

    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = with pkgs; [ lazygit ];

      file.xdg_config."lazygit/config.yml".source = ./config.yml;
    };
  };
}
