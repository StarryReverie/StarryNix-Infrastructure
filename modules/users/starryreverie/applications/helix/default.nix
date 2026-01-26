{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.helix;
in
{
  config = {
    custom.users.starryreverie = {
      core.environment = lib.mkIf customCfg.enable {
        sessionVariables = rec {
          EDITOR = lib.getExe pkgs.helix;
          VISUAL = EDITOR;
        };
      };
    };

    users.users.starryreverie.maid = lib.mkIf customCfg.enable {
      packages = with pkgs; [ helix ];

      file.xdg_config."helix/config.toml".source = ./config.toml;
      file.xdg_config."helix/languages.toml".source = ./languages.toml;

      file.xdg_config."helix/themes/one-dark-transparent.toml".source =
        ./themes/one-dark-transparent.toml;
      file.xdg_config."helix/themes/tokyo-night-storm-transparent.toml".source =
        ./themes/tokyo-night-storm-transparent.toml;
    };
  };
}
