{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
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
