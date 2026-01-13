{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [ keepassxc ];
  };

  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      directories = [ ".config/keepassxc" ];
    };
  };
}
