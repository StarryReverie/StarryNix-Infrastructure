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
      packages = with pkgs; [ fastfetchMinimal ];
    };

    custom.zsh = {
      shellAliases = {
        ff = "fastfetch";
      };
    };
  };
}
