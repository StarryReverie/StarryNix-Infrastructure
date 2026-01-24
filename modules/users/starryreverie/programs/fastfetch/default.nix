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

    custom.applications.zsh = {
      shellAliases = {
        ff = "fastfetch";
      };
    };
  };
}
