{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.lazygit;
in
{
  config = {
    custom.users.starryreverie = {
      applications.zsh = lib.mkIf customCfg.enable {
        shellAliases = {
          lg = "lazygit";
        };
      };
    };

    users.users.starryreverie.maid = lib.mkIf customCfg.enable {
      packages = with pkgs; [ lazygit ];

      file.xdg_config."lazygit/config.yml".source = ./config.yml;
    };
  };
}
