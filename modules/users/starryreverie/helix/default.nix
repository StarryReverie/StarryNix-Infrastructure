{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = [ pkgs.helix ];

      file.xdg_config."helix/config.toml".source = ./config.toml;
      file.xdg_config."helix/themes/one-dark-transparent.toml".source =
        ./themes/one-dark-transparent.toml;
      file.xdg_config."helix/themes/tokyo-night-storm-transparent.toml".source =
        ./themes/tokyo-night-storm-transparent.toml;
    };

    custom.environment = {
      sessionVariables = rec {
        EDITOR = lib.getExe pkgs.helix;
        VISUAL = EDITOR;
      };
    };
  };
}
