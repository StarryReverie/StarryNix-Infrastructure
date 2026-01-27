{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  config = lib.mkIf config.programs.firefox.enable {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".mozilla" ];
      };
    };
  };
}
