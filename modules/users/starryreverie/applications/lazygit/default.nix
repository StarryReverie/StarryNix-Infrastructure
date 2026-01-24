{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [ lazygit ];

      file.xdg_config."lazygit/config.yml".source = ./config.yml;
    };

    custom.applications.zsh = {
      shellAliases = {
        lg = "lazygit";
      };
    };
  };
}
