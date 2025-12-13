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
      packages = with pkgs; [ atuin ];

      file.xdg_config."atuin/config.toml".source = ./config.toml;
    };

    custom.zsh = {
      rcContent = ''
        # Atuin integration
        eval "$(${lib.getExe pkgs.atuin} init zsh)"
      '';
    };
  };
}
