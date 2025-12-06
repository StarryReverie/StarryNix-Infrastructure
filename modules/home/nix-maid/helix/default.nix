{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username} = {
    maid = {
      packages = [ pkgs.helix ];

      file.xdg_config."helix/config.toml".source = ./config.toml;
      file.xdg_config."helix/themes/one-dark-transparent.toml".source =
        ./themes/one-dark-transparent.toml;
      file.xdg_config."helix/themes/tokyo-night-storm-transparent.toml".source =
        ./themes/tokyo-night-storm-transparent.toml;
    };

    homeSessionVariables = rec {
      EDITOR = lib.getExe pkgs.helix;
      VISUAL = EDITOR;
    };
  };
}
