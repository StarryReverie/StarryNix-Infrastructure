{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  # Requires the corresponding system module
  imports = [ (flakeRoot + /modules/system/firefox) ];

  config = lib.mkIf config.programs.firefox.enable {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".mozilla" ];
      };
    };
  };
}
