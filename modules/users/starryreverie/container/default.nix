{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  # Requires the corresponding system module
  imports = [ (flakeRoot + /modules/system/container) ];

  config = lib.mkIf config.virtualisation.podman.enable {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/share/containers" ];
      };
    };
  };
}
