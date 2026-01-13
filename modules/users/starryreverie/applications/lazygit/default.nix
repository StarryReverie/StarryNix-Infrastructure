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

    custom.zsh = {
      shellAliases = {
        lg = "lazygit";
      };
    };
  };
}
