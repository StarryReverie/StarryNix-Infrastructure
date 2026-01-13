{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  # Requires the corresponding system module
  imports = [ (flakeRoot + /modules/system/hardware/pipewire) ];

  config = lib.mkIf config.services.pipewire.enable {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/state/wireplumber" ];
      };
    };
  };
}
